# Node + Express + MongoDB Notes

> Reference notes for backend projects using Node.js, Express, and MongoDB/Mongoose.

---

## Project Setup

```bash
mkdir project-api && cd project-api
npm init -y
npm install express mongoose dotenv cors
npm install --save-dev nodemon
```

### Folder structure
```
/src
  /routes       ← one file per resource
  /models       ← Mongoose schemas
  /middleware   ← auth, validation, error handling
  /controllers  ← business logic, called by routes
  server.js     ← entry point
.env
```

---

## Standard Server Setup

```js
// server.js
import express from 'express';
import mongoose from 'mongoose';
import cors from 'cors';
import dotenv from 'dotenv';

dotenv.config();
const app = express();

app.use(cors());
app.use(express.json());

mongoose.connect(process.env.MONGO_URI)
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.error(err));

app.listen(process.env.PORT || 3000);
```

---

## Standard Response Shape

```js
// Success
res.json({ success: true, data: result });

// Error
res.status(400).json({ success: false, error: 'Message here' });
```

---

## Mongoose Patterns

```js
// Always use .lean() for read-only queries
const users = await User.find({ active: true }).lean();

// Always handle errors in async routes
const getUser = async (req, res) => {
  try {
    const user = await User.findById(req.params.id).lean();
    if (!user) return res.status(404).json({ success: false, error: 'Not found' });
    res.json({ success: true, data: user });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
};
```

---

## Gotchas

- `mongoose.connect()` is async — make sure it resolves before starting the server in tests
- `.lean()` returns plain JS objects, not Mongoose documents — methods like `.save()` won't work on them
- Always add `{ timestamps: true }` to schemas for free `createdAt` / `updatedAt` fields
- MongoDB ObjectId comparisons need `.toString()` or `.equals()` — `===` won't work directly
