# Silabus Praktikum JavaScript & TypeScript

Target: siap live coding TypeScript (pair work) paling lambat 3 minggu, idealnya 2 minggu sejak 1 November 2026.

## Jadwal

Hari kerja 1 topik per hari (sekitar 2 jam). Akhir pekan 3 topik per hari.

| Tanggal | Hari | Isi |
|---|---|---|
| 1 Nov | Minggu | JS-1, JS-2, JS-3 |
| 2–6 Nov | Senin–Jumat | JS-4 sampai JS-8 |
| 7 Nov | Sabtu | TS-1, TS-2, TS-3 |
| 8 Nov | Minggu | TS-4, TS-5, TS-6 |
| 9 Nov | Senin | TS-7 REST API (opsional) |
| 10–11 Nov | Selasa–Rabu | Tugas Rancang (6 jam) |

Cadangan: 12–15 Nov. Topik yang molor menggeser jadwal; tidak ada topik yang dilewati.

## Topik JavaScript

1. **Variabel dan kondisi**: `const`/`let`/`var`, tipe data, operator, `===` vs `==`, truthy/falsy, `if`/`else`, `switch`, ternary.
2. **Perulangan dan fungsi**: `for`, `while`, `for...of`, function declaration vs arrow function, parameter default, scope, return.
3. **Array**: `forEach`, `map`, `filter`, `reduce`, `find`, `some`, `every`, `includes`, `sort`. `for` vs `forEach`.
4. **String dan object**: method string, string sebagai "mirip array", object literal, destructuring, spread, salinan dangkal vs dalam, JSON.
5. **OOP**: `class`, constructor, method, getter, field `#private`, `extends`/`super`, object literal vs class.
6. **Modules dan standard library**: `import`/`export`, `Math`, `Date`, `Map`, `Set`, `Intl.NumberFormat`, `throw`/`try`/`catch`.
7. **Async**: callback, Promise, `async`/`await`, `fetch`, error handling async.
8. **DOM**: `querySelector`, event listener, render daftar dari array, form, mini halaman checkout.

## Topik TypeScript

1. **Dasar**: setup, type annotation, inference, union dan literal type, function type, `any` vs `unknown`, `strictNullChecks`.
2. **Object type**: `type` vs `interface`, optional, `readonly`, array, tuple, `Record`.
3. **OOP**: access modifier, `implements`, abstract class. Object vs Class vs Interface.
4. **Generics**: fungsi generik, constraint, generic class/interface, `Partial`, `Pick`, `Omit`.
5. **Narrowing dan error handling**: `typeof`, `in`, `instanceof`, discriminated union, custom `Error`, pola Result.
6. **Validation**: data luar bertipe `unknown`, type guard, `zod`.
7. **REST API (opsional)**: Express + TypeScript, CRUD in-memory, status code, validasi request.

**Tugas Rancang**: aplikasi kasir supermarket dengan dompet saldo (deposit, withdraw, bayar memakai saldo) dalam TypeScript, skala 6 jam.

## Pemetaan poin interviewer

| Poin interviewer | Topik |
|---|---|
| `const`, `var`, `let` | JS-1, TS-1 |
| Kondisi `if` | JS-1 |
| `for` vs `forEach` | JS-2, JS-3 |
| Array: `map`, `includes`, `reduce`, `forEach` | JS-3 |
| String manipulation | JS-4 |
| Strongly typed variable dan function | TS-1 |
| Object vs Class vs Interface | JS-5, TS-3 |
| Sistem saldo, checkout supermarket | soal di banyak topik, Tugas Rancang |

## Domain kasus

Kasir supermarket, dompet/bank, sistem rumah sakit, marketplace.
