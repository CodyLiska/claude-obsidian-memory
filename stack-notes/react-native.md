# React Native Notes

> Reference notes for React Native projects.

---

## Project Setup

```bash
npx create-expo-app project-name
cd project-name
npx expo start
```

---

## Patterns

### Component structure

```jsx
import { StyleSheet, View, Text } from "react-native";

export default function MyComponent({ title }) {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>{title}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, padding: 16 },
  title: { fontSize: 18, fontWeight: "bold" },
});
```

### Navigation (React Navigation)

```bash
npm install @react-navigation/native @react-navigation/stack
```

- Keep all navigation config in a dedicated `navigation/` folder
- Don't call `navigate()` from inside components directly — pass as prop or use hook

---

## Gotchas

- Always test on both iOS and Android — layout differences are common with flexbox defaults
- `StyleSheet.create()` is required — inline style objects cause unnecessary re-renders
- `ScrollView` vs `FlatList` — use `FlatList` for any list that could grow, `ScrollView` only for static content
- Platform-specific code: use `Platform.OS === 'ios'` checks or `.ios.js` / `.android.js` file extensions
- Expo Go has limitations — some native modules require a development build
