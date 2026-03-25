# Vue + Tailwind Notes

> Reference notes for Vue 3 and Tailwind CSS patterns Cody uses regularly. Claude should read this when working on frontend projects.

---

## Project Setup

```bash
npm create vue@latest
# Select: TypeScript? No, JSX? No, Vue Router? Yes, Pinia? Yes, Vitest? optional, ESLint? Yes
cd project-name
npm install
npx tailwindcss init
```

### Tailwind config for Vue

```js
// tailwind.config.js
export default {
  content: ["./index.html", "./src/**/*.{vue,js,ts}"],
  theme: { extend: {} },
  plugins: [],
};
```

---

## Patterns

### Composables (preferred over mixins)

```js
// src/composables/useAuth.js
import { ref } from 'vue';

export function useAuth() {
  const user = ref(null);
  const login = async (credentials) => { ... };
  return { user, login };
}
```

### Component structure order

```vue
<template>...</template>
<script setup>
...
</script>
<style scoped>
...
</style>
```

---

## Common Tailwind Patterns

- Responsive container: `class="max-w-4xl mx-auto px-4"`
- Flex center: `class="flex items-center justify-center"`
- Card: `class="bg-white rounded-lg shadow-md p-6"`
- Button primary: `class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded"`

---

## Gotchas

- Always use `scoped` styles in components to avoid bleed
- Tailwind purges unused classes in production — make sure dynamic class names are complete strings, not concatenated
- Vue Router `<RouterLink>` doesn't inherit Tailwind focus styles automatically — add them explicitly
