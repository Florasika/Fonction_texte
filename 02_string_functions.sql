-- ============================================================
--  JOUR 8 / 10 DAYS OF SQL — Fonctions de Texte
--  Concepts : TRIM · UPPER/LOWER · SUBSTR · REPLACE
--             || (concaténation) · LENGTH · INSTR
-- ============================================================

-- ── 1. TRIM() : supprimer les espaces en trop ────────────────
SELECT
    nom_complet AS original,
    TRIM(nom_complet) AS nettoye
FROM contacts;

-- TRIM() enlève les espaces au DÉBUT et à la FIN (pas au milieu)
-- LTRIM() = seulement à gauche, RTRIM() = seulement à droite


-- ── 2. UPPER() / LOWER() : harmoniser la casse ───────────────
SELECT
    ville AS original,
    UPPER(ville) AS majuscules,
    LOWER(ville) AS minuscules
FROM contacts;


-- ── 3. Combiner TRIM + nettoyage de casse pour standardiser ──
-- Nettoyer la ville : trim + première lettre majuscule (simulé)
SELECT
    ville AS original,
    UPPER(SUBSTR(TRIM(LOWER(ville)), 1, 1)) ||
    SUBSTR(TRIM(LOWER(ville)), 2) AS ville_propre
FROM contacts;

-- Technique : UPPER(1ère lettre) + reste en minuscule
-- = simulation d'un "Title Case" qui n'existe pas nativement en SQLite


-- ── 4. || : concaténation de chaînes ──────────────────────────
SELECT
    nom_complet,
    email,
    TRIM(nom_complet) || ' <' || LOWER(TRIM(email)) || '>' AS contact_formate
FROM contacts;

-- || est l'opérateur de concaténation standard SQL (SQLite, PostgreSQL)
-- MySQL utilise CONCAT(a, b, c) à la place


-- ── 5. LENGTH() : compter les caractères ──────────────────────
SELECT
    email,
    LENGTH(email) AS nb_caracteres
FROM contacts
ORDER BY nb_caracteres DESC;


-- ── 6. SUBSTR() : extraire une partie du texte ───────────────
-- Extraire le domaine de l'email (après le @)
SELECT
    email,
    SUBSTR(email, INSTR(email, '@') + 1) AS domaine
FROM contacts;

-- SUBSTR(texte, position_debut, longueur)
-- INSTR(texte, sous_chaine) trouve la POSITION du caractère recherché


-- ── 7. INSTR() : trouver la position d'un caractère ──────────
SELECT
    email,
    INSTR(email, '@') AS position_arobase
FROM contacts;


-- ── 8. REPLACE() : remplacer du texte ─────────────────────────
-- Nettoyer les numéros de téléphone (enlever espaces, tirets, points)
SELECT
    telephone AS original,
    REPLACE(
        REPLACE(
            REPLACE(telephone, '-', ''),
        '.', ''),
    ' ', '') AS telephone_nettoye
FROM contacts;

-- REPLACE imbriqués : chaque appel enlève un type de séparateur
-- L'ordre n'a pas d'importance ici car les remplacements sont indépendants


-- ── 9. Email en minuscules + sans espace (nettoyage complet) ─
SELECT
    nom_complet,
    email AS email_original,
    LOWER(TRIM(email)) AS email_nettoye
FROM contacts
ORDER BY id;


-- ── 10. Séparer prénom et nom (approximatif avec INSTR) ──────
-- Extraire le premier "mot" comme prénom approximatif
SELECT
    TRIM(nom_complet) AS nom_complet_propre,
    SUBSTR(TRIM(nom_complet), 1, INSTR(TRIM(nom_complet) || ' ', ' ') - 1) AS premier_mot
FROM contacts;

-- Astuce : ajouter ' ' à la fin garantit qu'INSTR trouve toujours un espace
-- même si nom_complet ne contient qu'un seul mot


-- ── 11. CASE + LIKE : valider un format ──────────────────────
-- Vérifier que l'email contient bien un @ et un .
SELECT
    email,
    CASE
        WHEN email LIKE '%@%.%' THEN '✓ Format valide'
        ELSE '✗ Format suspect'
    END AS validation_email
FROM contacts;


-- ── 12. COALESCE() : gérer les valeurs NULL dans du texte ────
SELECT
    nom_complet,
    COALESCE(notes, 'Aucune note') AS notes_affichees
FROM contacts;

-- COALESCE renvoie la PREMIÈRE valeur non-NULL de la liste
-- Très utilisé pour éviter d'afficher NULL à l'utilisateur final


-- ── 13. REQUÊTE COMPLÈTE — Nettoyage et standardisation totale ─
SELECT
    id,
    -- Nom propre : trim + espaces multiples réduits (approximation)
    TRIM(nom_complet) AS nom_propre,

    -- Email propre : trim + minuscules
    LOWER(TRIM(email)) AS email_propre,

    -- Téléphone propre : sans séparateurs
    REPLACE(REPLACE(REPLACE(telephone, '-', ''), '.', ''), ' ', '') AS telephone_propre,

    -- Ville propre : Title Case
    UPPER(SUBSTR(TRIM(LOWER(ville)), 1, 1)) || SUBSTR(TRIM(LOWER(ville)), 2) AS ville_propre,

    -- Notes avec valeur par défaut
    COALESCE(notes, 'Aucune note') AS notes_propres

FROM contacts
ORDER BY id;
