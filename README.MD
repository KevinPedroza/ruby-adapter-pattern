# Adapter Pattern in Ruby – Workshop

## 📌 Overview
This workshop explores the **Adapter Design Pattern**, a structural pattern that helps objects with incompatible interfaces work together. You’ll learn how to implement adapters in Ruby, understand when to use them, and see real-world use cases.

---

## 🔍 What is the Adapter Pattern?
The **Adapter Pattern** acts as a bridge between two incompatible interfaces. It wraps an existing class with a new interface so that it can work with the client code expecting a different interface.

**Why use it?**
- To integrate legacy code with new systems.
- To connect APIs or libraries that don’t naturally fit together.
- To preserve encapsulation while avoiding massive code rewrites.

---

## ✅ Learning Goals
- Understand the **problem of interface incompatibility**.
- Implement an **Adapter class** in Ruby.
- Learn Ruby-specific alternatives:
  - **Reopening classes** (monkey patching).
  - **Adding singleton methods** to an instance.
- Explore **real-world uses**, such as in Rails’ `ActiveRecord`.

## ⚠️ Best Practices
### Use Adapters When:

- The mismatch is complex or you want to maintain encapsulation.

### Modify Classes When:

- Changes are minor and safe, and you control the class.

## 🌍 Real-World Example
Rails’ ActiveRecord uses adapters to standardize database communication. For example:

MysqlAdapter, OracleAdapter, and PostgresAdapter all implement a common interface like select_all.
