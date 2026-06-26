# 🔤 Jour 8 / 10 — SQL : Fonctions de Texte

> **Série : 10 Days of SQL** · Jour 8/10  
> Concepts : TRIM · UPPER/LOWER · SUBSTR · INSTR · REPLACE · || (concaténation) · COALESCE

---

## 📁 Structure du projet

```
day-08-string-functions/
│
├── 01_setup.sql              ← CREATE TABLE contacts + 12 lignes (données "sales")
├── 02_string_functions.sql   ← 13 requêtes commentées
├── contacts.db                ← Base SQLite prête à l'emploi
└── README.md
```

---

## 🚀 Installation & Lancement

```bash
# Cloner le repo
git clone https://github.com/ton-pseudo/10-days-sql.git
cd 10-days-sql/day-08-string-functions

# Ouvrir la base directement (déjà créée)
sqlite3 contacts.db

# OU recréer la base depuis zéro
sqlite3 contacts.db < 01_setup.sql

# Exécuter toutes les requêtes
sqlite3 contacts.db < 02_string_functions.sql
```

---

## 📊 Le schéma — table `contacts`

| Colonne | Type | Description |
|---------|------|--------------|
| `id` | INTEGER | Clé primaire |
| `nom_complet` | TEXT | Casse et espaces incohérents (volontaire) |
| `email` | TEXT | Mélange majuscules/minuscules, espaces parasites |
| `telephone` | TEXT | 4 formats différents : `0612345678`, `06-23-45-67-89`, `06.45.67.89.01`, `06 67 89 01 23` |
| `ville` | TEXT | Casse incohérente : `paris`, `PARIS`, `Lyon` |
| `notes` | TEXT | Certaines valeurs `NULL` |

12 contacts **volontairement sales** — c'est le genre de données qu'on reçoit vraiment d'un export CSV ou d'un formulaire web mal validé.

---

## 🔑 1. TRIM() — supprimer les espaces parasites

```sql
SELECT nom_complet, TRIM(nom_complet) AS nettoye
FROM contacts;
```
`TRIM()` enlève les espaces au **début et à la fin** uniquement (pas au milieu du texte).
- `LTRIM()` → seulement à gauche
- `RTRIM()` → seulement à droite

---

## 🔑 2. UPPER() / LOWER() — harmoniser la casse

```sql
SELECT ville, UPPER(ville) AS majuscules, LOWER(ville) AS minuscules
FROM contacts;
```

---

## 🔑 3. Simuler un Title Case (1ère lettre majuscule)

SQLite n'a pas de fonction `INITCAP()` native (contrairement à PostgreSQL). On la simule :

```sql
SELECT
    UPPER(SUBSTR(TRIM(LOWER(ville)), 1, 1)) ||
    SUBSTR(TRIM(LOWER(ville)), 2) AS ville_propre
FROM contacts;
```
**Logique** : on met tout en minuscule, puis on prend le premier caractère en majuscule (`SUBSTR(..., 1, 1)`) et on le concatène (`||`) avec le reste de la chaîne (`SUBSTR(..., 2)`).

---

## 🔑 4. || — concaténer des chaînes

```sql
SELECT TRIM(nom_complet) || ' <' || LOWER(TRIM(email)) || '>' AS contact_formate
FROM contacts;
```
`||` est l'opérateur standard SQL de concaténation (SQLite, PostgreSQL, Oracle). **MySQL** utilise `CONCAT(a, b, c)` à la place — différence à connaître si tu changes de moteur.

---

## 🔑 5. SUBSTR() + INSTR() — extraire une partie du texte

```sql
-- Extraire le domaine d'un email (après le @)
SELECT email, SUBSTR(email, INSTR(email, '@') + 1) AS domaine
FROM contacts;
```
- `INSTR(texte, sous_chaine)` → trouve la **position** d'un caractère/mot
- `SUBSTR(texte, position_début, longueur)` → extrait une portion du texte (la longueur est optionnelle, va jusqu'à la fin si omise)

### Extraire le premier mot (prénom approximatif)
```sql
SUBSTR(TRIM(nom_complet), 1, INSTR(TRIM(nom_complet) || ' ', ' ') - 1)
```
💡 Astuce : ajouter un espace à la fin (`|| ' '`) garantit qu'`INSTR` trouve toujours un espace, même si le texte ne contient qu'un seul mot.

---

## 🔑 6. REPLACE() — remplacer du texte

```sql
-- Nettoyer un numéro de téléphone (4 formats différents → 1 seul)
SELECT telephone,
    REPLACE(REPLACE(REPLACE(telephone, '-', ''), '.', ''), ' ', '') AS telephone_propre
FROM contacts;
```
Chaque `REPLACE` imbriqué enlève un type de séparateur. L'ordre n'a pas d'importance ici car les remplacements sont indépendants les uns des autres.

---

## 🔑 7. COALESCE() — gérer les valeurs NULL

```sql
SELECT nom_complet, COALESCE(notes, 'Aucune note') AS notes_affichees
FROM contacts;
```
`COALESCE()` renvoie la **première valeur non-NULL** de la liste fournie. Très utilisé pour éviter d'afficher `NULL` brut à l'utilisateur final — peut aussi prendre plusieurs colonnes en fallback : `COALESCE(telephone_mobile, telephone_fixe, 'Non renseigné')`.

---

## 🔑 8. Valider un format avec LIKE

```sql
SELECT email,
    CASE WHEN email LIKE '%@%.%' THEN '✓ Format valide' ELSE '✗ Format suspect' END AS validation
FROM contacts;
```
Une validation basique mais utile pour repérer rapidement les emails mal formés dans un import.

---

## 🧠 Requête de nettoyage complet

```sql
SELECT
    TRIM(nom_complet) AS nom_propre,
    LOWER(TRIM(email)) AS email_propre,
    REPLACE(REPLACE(REPLACE(telephone, '-', ''), '.', ''), ' ', '') AS telephone_propre,
    UPPER(SUBSTR(TRIM(LOWER(ville)), 1, 1)) || SUBSTR(TRIM(LOWER(ville)), 2) AS ville_propre,
    COALESCE(notes, 'Aucune note') AS notes_propres
FROM contacts;
```
Combine **toutes** les fonctions vues dans ce fichier en une seule requête de nettoyage — exactement le genre de requête qu'on écrit avant d'exporter des données propres vers un autre système.

---

## 💡 Quand utiliser quoi ?

| Besoin | Fonction |
|---|---|
| Enlever espaces début/fin | `TRIM()` |
| Harmoniser la casse | `UPPER()` / `LOWER()` |
| Extraire une portion de texte | `SUBSTR(texte, début, longueur)` |
| Trouver la position d'un caractère | `INSTR(texte, sous_chaine)` |
| Remplacer du texte | `REPLACE(texte, ancien, nouveau)` |
| Assembler des chaînes | `texte1 \|\| texte2` |
| Remplacer un NULL par une valeur par défaut | `COALESCE(colonne, 'défaut')` |
| Compter les caractères | `LENGTH()` |

---


---

⭐ **Si ce projet t'aide, mets une étoile !**
