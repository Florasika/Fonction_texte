-- ============================================================
--  JOUR 8 / 10 DAYS OF SQL — Setup : Fonctions de Texte
--  Table : contacts (données volontairement "sales" à nettoyer)
-- ============================================================

DROP TABLE IF EXISTS contacts;

CREATE TABLE contacts (
    id          INTEGER PRIMARY KEY,
    nom_complet TEXT NOT NULL,      -- format incohérent volontaire
    email       TEXT NOT NULL,
    telephone   TEXT NOT NULL,
    ville       TEXT NOT NULL,
    notes       TEXT
);

INSERT INTO contacts (id, nom_complet, email, telephone, ville, notes) VALUES
(1,  '  Alice MARTIN  ',     'alice.martin@CORP.FR',     '0612345678',     'paris',       'Client VIP - a contacter rapidement'),
(2,  'karim benali',         'KBenali@corp.fr',          '06-23-45-67-89', 'MARSEILLE',   NULL),
(3,  'Lucie   Dubois',       'lucie.dubois@corp.fr  ',   '0634567890',     'Lyon',        'Prefere email'),
(4,  'THOMAS roux',          'thomas.roux@corp.fr',      '06.45.67.89.01', 'paris',       NULL),
(5,  'nadia KHELIFI',        'Nadia.Khelifi@CORP.FR',    '0656789012',     'Toulouse',    'Nouveau client 2024'),
(6,  'Julien Petit  ',       'julien.petit@corp.fr',     '06 67 89 01 23', 'PARIS',       NULL),
(7,  '  sophie moreau',      'SOPHIE.MOREAU@corp.fr',    '0678901234',     'lyon',        'Suivi mensuel'),
(8,  'Pierre LAMBERT',       'pierre.lambert@corp.fr ',  '06-89-01-23-45', 'Bordeaux',    NULL),
(9,  'emma garcia',          'emma.garcia@CORP.FR',      '0690123456',     'paris',       'Compte premium'),
(10, 'Maxime   DAVID',       'maxime.david@corp.fr',     '06.01.23.45.67', 'Lyon',        NULL),
(11, 'Chloe BERTRAND',       'Chloe.Bertrand@corp.fr',   '0612340000',     'MARSEILLE',   'Contact urgent'),
(12, '  Hugo Fontaine',      'hugo.fontaine@CORP.FR',    '06-23-40-00-11', 'paris',       NULL);
