---
name: test-generator
description: Generates comprehensive tests (unit, integration, e2e) based on implementation code and requirements.
---
## Test Generator Skill

Generate **risk-based** tests for implemented code. Goal is NOT coverage % —
goal is tests where a bug costs money, data, or a core flow.

### Prerequisites — read before writing any test
1. **TESTING-POLICY.md** — MANDATORY. Defines MUST-test vs DO NOT test. Do not write a test the policy lists under "Do NOT test".
2. **DATA_MODEL.md** — if testing DB code (routes, queries, schema changes). Know the schema before mocking it.
3. **CLAUDE.md §2** — test commands, runtime/version requirements for the test runner.

### Step 0: Triage gate (do this BEFORE writing any test)
Classify every changed file/symbol per the policy into a triage table
(MUST-test vs SKIP, with reason). Write tests ONLY for MUST-test rows. Emit the
table in your output. If all rows are SKIP, write zero tests and say so — valid.

```
| Symbol/File         | Class       | Test? | Why                      |
|---------------------|-------------|-------|--------------------------|
| resolveSafePath()   | security    | YES   | path-traversal boundary  |
| featureRoute()      | biz-logic   | YES   | branchy, handles auth    |
| FeatureCard.tsx     | dumb-ui     | NO    | no logic/interaction     |
| useFoo internal var | impl-detail | NO    | refactor-fragile         |
```

### Prerequisites
Read `CLAUDE.md` to understand:
- Testing frameworks in use (Vitest, Jest, Pytest, Playwright, etc.)
- Test file naming conventions
- Mock/stub strategies

### Test Types

#### Unit Tests
- Test individual functions/methods in isolation
- Mock all external dependencies
- Focus on edge cases and boundary conditions
- One test file per source file

#### Integration Tests
- Test component/module interactions
- Use real implementations where practical
- Test API endpoints with database
- Test component compositions

#### E2E Tests (Playwright/Cypress)
- Test critical user flows
- Happy path scenarios
- Error state handling
- Authentication flows

### Step 1: Analyze Implementation
```bash
git diff --name-only HEAD~1
# Or for feature branch:
git diff --name-only main...HEAD
```

Read each changed file to understand public APIs, input types, error conditions, and dependencies to mock.

### Step 2: Write Tests

#### Unit Test Template (JavaScript/TypeScript)
```typescript
import { describe, it, expect, vi } from 'vitest'; // or jest
import { functionName } from './module';

describe('functionName', () => {
  describe('happy path', () => {
    it('should return expected result for valid input', () => {
      const result = functionName(validInput);
      expect(result).toEqual(expectedOutput);
    });
  });

  describe('edge cases', () => {
    it('should handle empty input', () => {
      expect(() => functionName('')).toThrow();
    });

    it('should handle null input', () => {
      expect(functionName(null)).toBeNull();
    });
  });

  describe('error handling', () => {
    it('should throw on invalid input', () => {
      expect(() => functionName(invalidInput)).toThrow(ExpectedError);
    });
  });
});
```

#### Unit Test Template (Python)
```python
import pytest
from module import function_name

class TestFunctionName:
    def test_happy_path(self):
        result = function_name(valid_input)
        assert result == expected_output

    def test_empty_input(self):
        with pytest.raises(ValueError):
            function_name('')

    def test_edge_case(self):
        result = function_name(boundary_value)
        assert result == expected_boundary_output
```

#### E2E Test Template (Playwright)
```typescript
import { test, expect } from '@playwright/test';

test.describe('Feature Name', () => {
  test('user can complete flow', async ({ page }) => {
    await page.goto('/feature-page');
    await page.fill('[data-testid="input"]', 'value');
    await page.click('[data-testid="submit"]');
    await expect(page.locator('[data-testid="result"]'))
      .toHaveText('expected result');
  });

  test('handles error state', async ({ page }) => {
    // Test error scenario
  });
});
```

### Step 3: Verify Coverage
Coverage is **informational, not a target**. Confirm every MUST-test item has a test; ignore gaps that fall only on SKIP-class code.

Use coverage command from CLAUDE.md §2. Coverage is informational — not a gate.

### Test Naming Conventions
- Unit tests: `<filename>.test.ts` or `test_<filename>.py`
- Integration: `<feature>.integration.test.ts`
- E2E: `<feature>.spec.ts` or `<feature>.e2e.ts`

### Output Format
```
## Tests Generated

**Triage table (policy-based):**
| Symbol/File | Class | Test? | Why |
|-------------|-------|-------|-----|
| featureRoute() | biz-logic | YES | branchy, handles auth |
| FeatureCard.tsx | dumb-ui | NO | no logic/interaction |

**Files created:**
- src/__tests__/newFeature.test.ts (8 tests)
- e2e/newFeature.spec.ts (3 tests)

**Coverage:** New code coverage at 87%

**Test summary:**
- Unit: 8 tests
- Integration: 0 tests
- E2E: 3 tests
- Total: 11 tests
```

### Guidelines
- One assertion per test when practical
- Use descriptive test names (should_do_X_when_Y)
- Mock external services (APIs, databases in unit tests)
- Include both positive and negative test cases
- Test the public API, not internal implementation

### TDD-First Mode
- Write tests BEFORE any implementation exists
- Tests MUST fail initially (red phase) — validates the test is meaningful
- Use mocks/stubs/interfaces for dependencies that haven't been built yet
- Import from future source paths (e.g., `import { newFunction } from '../src/newModule'`)
- Tests serve as the executable specification for implementation to run against
