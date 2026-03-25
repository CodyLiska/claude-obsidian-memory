# Coding Conventions

> These are Cody's personal coding standards. Claude should follow these in all sessions unless explicitly told otherwise for a specific project.

---

## Tech Stack Defaults

| Layer    | Default Choice     |
| -------- | ------------------ |
| Frontend | Vue + Tailwind CSS |
| Backend  | Node.js + Express  |
| Database | MongoDB            |
| Mobile   | React Native       |

---

## JavaScript / TypeScript Style

- **Indentation:** 2 spaces
- **Quotes:** Single quotes (`'`) for strings
- **Semicolons:** Always — every statement ends with `;`
- **Code organization:** Mixed — use functions or classes based on what fits the context. Don't force a pattern.

### Naming Conventions

- Variables and functions: `camelCase`
- Components (Vue, React Native): `PascalCase`
- Constants: `UPPER_SNAKE_CASE`
- Files: `kebab-case` for utilities and pages, `PascalCase` for components

### Functions

- Prefer arrow functions for callbacks and short utilities
- Use named functions for top-level declarations and anything that needs to be readable in a stack trace
- Keep functions small and single-purpose — if it's doing two things, split it

### Error Handling

- Always use try/catch for async operations
- Never silently swallow errors — at minimum log them
- Return meaningful error messages from APIs, not raw stack traces

---

## Comments

- **Write comments on complex logic** — if the code does something non-obvious, explain the why not the what
- **Comments only when something is non-obvious** — don't narrate obvious code
- No JSDoc required unless building a shared library or SDK
- Prefer clear variable and function names over compensatory comments

### Good comment example

```js
// MongoDB TTL index won't fire immediately — add a 5min buffer to avoid
// race conditions with the cleanup job
const expiresAt = new Date(Date.now() + SESSION_DURATION + 300000);
```

### Bad comment example

```js
// increment i by 1
i++;
```

---

## Vue Conventions

- Use Composition API (`<script setup>`) over Options API for all new components
- Keep components focused — if a component is doing too much, extract child components
- Props should always be typed and have defaults where sensible
- Use Tailwind utility classes directly in templates — avoid inline `style` attributes
- Organize template → script → style in that order in `.vue` files

---

## Node / Express Conventions

- Organize routes by resource (e.g. `/routes/users.js`, `/routes/projects.js`)
- Use middleware for auth, validation, and error handling — don't repeat logic in route handlers
- Always validate request body before processing
- Use async/await over callbacks or raw promise chains
- Return consistent response shapes:

```js
// Success
{ success: true, data: { ... } }

// Error
{ success: false, error: 'Human readable message' }
```

---

## MongoDB Conventions

- Use Mongoose for schema definition and validation
- Define indexes explicitly in the schema — don't rely on defaults
- Never store sensitive data (passwords, tokens) in plain text
- Use `.lean()` for read-only queries that don't need Mongoose document methods

---

## React Native Conventions

- Use functional components with hooks only — no class components
- StyleSheet.create() for all styles — no inline style objects
- Keep navigation logic out of components — use navigation props or context
- Test on both iOS and Android before considering a feature done

---

## Git Conventions

- Commit messages: `type: short description` (e.g. `feat: add user auth`, `fix: correct token expiry`)
- Types: `feat`, `fix`, `refactor`, `chore`, `docs`, `style`, `test`
- Commit small and often — don't bundle unrelated changes
- Branch naming: `feature/short-description`, `fix/short-description`

---

## General Principles

- **Don't repeat yourself** — if you write the same logic twice, extract it
- **Fail loudly in development, gracefully in production**
- **Keep dependencies minimal** — don't add a package for something you can write in 10 lines
- **Readable over clever** — future Cody should understand this without context
