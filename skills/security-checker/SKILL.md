---
name: security-checker
description: Performs OWASP-based security checks on code changes, identifying vulnerabilities and enforcing security best practices.
---
## Security Checker Skill

Automated security analysis following OWASP guidelines and industry best practices.

### Prerequisites
Read `CLAUDE.md` → Dev Commands and run:
- Backend security scanner command (if defined)
- Frontend dependency audit if applicable

Example commands vary by stack:
- Go: `gosec ./...` + `govulncheck ./...`
- Python: `bandit -r src/` + `pip-audit`
- Node: `npm audit --audit-level=moderate`

### Security Checklist (OWASP Top 10)

#### A01: Broken Access Control
- [ ] Authorization checks on all endpoints
- [ ] No direct object references exposed
- [ ] Role-based access properly enforced
- [ ] CORS configured correctly
- [ ] No privilege escalation paths

#### A02: Cryptographic Failures
- [ ] Sensitive data encrypted at rest
- [ ] TLS/HTTPS for data in transit
- [ ] Strong hashing for passwords (bcrypt, argon2)
- [ ] No hardcoded secrets
- [ ] Secure key management

#### A03: Injection
- [ ] Parameterized queries (no SQL concatenation)
- [ ] Input sanitization
- [ ] Command injection prevention
- [ ] XSS prevention (output encoding)
- [ ] Template injection prevention

#### A04: Insecure Design
- [ ] Threat modeling considered
- [ ] Defense in depth applied
- [ ] Principle of least privilege
- [ ] Secure defaults

#### A05: Security Misconfiguration
- [ ] No debug mode in production
- [ ] Security headers configured
- [ ] Unnecessary features disabled
- [ ] Default credentials changed
- [ ] Error messages don't leak info

#### A06: Vulnerable Components
- [ ] Dependencies up to date
- [ ] No known CVEs in dependencies
- [ ] Minimal dependency footprint
- [ ] Lock files committed

#### A07: Authentication Failures
- [ ] Strong password policies
- [ ] Rate limiting on auth endpoints
- [ ] Secure session management
- [ ] Multi-factor where appropriate
- [ ] Proper logout/session invalidation

#### A08: Data Integrity Failures
- [ ] Signed JWTs
- [ ] Integrity checks on critical data
- [ ] Secure deserialization
- [ ] CI/CD pipeline security

#### A09: Security Logging
- [ ] Security events logged
- [ ] No sensitive data in logs
- [ ] Log injection prevention
- [ ] Audit trail for critical actions

#### A10: Server-Side Request Forgery (SSRF)
- [ ] URL validation for external requests
- [ ] Whitelist for allowed destinations
- [ ] No user-controlled redirects

### Step 1: Automated Scan
```bash
# Backend security scanner (as defined in CLAUDE.md → Dev Commands)
<backend security scanner command>

# Check for secrets (always)
git secrets --scan

# Frontend dependency audit (if applicable)
<frontend audit command if applicable>
```

### Step 2: Manual Review

#### Authentication Code
```javascript
// VULNERABLE
const token = jwt.sign(payload, 'hardcoded-secret');

// SECURE
const token = jwt.sign(payload, process.env.JWT_SECRET);
```

#### Database Queries
```javascript
// VULNERABLE (SQL Injection)
const query = `SELECT * FROM users WHERE id = ${userId}`;

// SECURE (Parameterized)
const query = 'SELECT * FROM users WHERE id = $1';
await db.query(query, [userId]);
```

#### Input Validation
```javascript
// VULNERABLE
const filename = req.query.file;
fs.readFile(`/uploads/${filename}`);

// SECURE
const filename = path.basename(req.query.file);
if (!allowedExtensions.includes(path.extname(filename))) {
  throw new Error('Invalid file type');
}
fs.readFile(path.join('/uploads', filename));
```

### Gate Decision

**PASS (Green):**
- No Critical or High findings
- All Medium findings have documented exceptions
- Dependencies have no critical CVEs

**NEEDS_ATTENTION (Yellow):**
- Medium findings present but not blocking
- Low/Info findings for awareness
- Dependencies have non-critical CVEs

**FAIL (Red):**
- Any Critical finding
- Any High finding without immediate fix
- Dependencies with critical CVEs

### Output Format

```
## Security Scan Complete

**Status:** NEEDS_ATTENTION

### Findings
- Critical: 0
- High: 1 (requires fix) — hardcoded secret in tokenService.ts:45
- Medium: 2 (recommended)
- Low: 3 (info)

### Required Actions
1. Fix hardcoded secret in tokenService.ts → move to process.env

### Recommendations
1. Add rate limiting to login endpoint
2. Update lodash to 4.17.21

Gate Status: BLOCKED until high finding resolved
```
