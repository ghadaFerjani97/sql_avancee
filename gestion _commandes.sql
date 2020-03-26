SELECT *
FROM employes
ORDER BY matricule
LIMIT 2
OFFSET 2;


SELECT id_article, id_post, ts, message
FROM posts
WHERE id_article = 1907
ORDER BY id_post
LIMIT 10;


SELECT id_article, id_post, ts, message
FROM posts
WHERE id_article = 1907
ORDER BY id_post
LIMIT 10
OFFSET 1000;


CREATE TABLE test_returning (id serial primary key, val integer);

INSERT INTO test_returning (val) VALUES (10)
RETURNING id, val;

INSERT INTO employes (matricule, nom, service, salaire)
VALUES ('00000001', 'Marsupilami', 'Direction', 50000.00)
ON CONFLICT DO NOTHING;


CREATE TABLE test_upsert (i serial PRIMARY KEY, v text UNIQUE, x integer CHECK (x > 0));


INSERT INTO employes (matricule, nom, service, salaire)
VALUES ('00000001', 'M. Pirate', 'Direction', 0.00)
ON CONFLICT (matricule)
DO UPDATE SET salaire = employes.salaire,nom = excluded.nom
RETURNING *;


INSERT INTO employes (matricule, nom, service, salaire)
VALUES ('00000001', 'Marsupilami', 'Direction', 50000.00)
ON CONFLICT ON CONSTRAINT employes_pkey DO UPDATE SET salaire = excluded.salaire;

WITH resume_commandes AS (
SELECT c.numero_commande, c.client_id, quantite*prix_unitaire AS montant
  FROM commandes c
  JOIN lignes_commandes l
    ON (c.numero_commande = l.numero_commande)
 WHERE date_commande BETWEEN '2014-01-01' AND '2014-12-31'
)

SELECT type_client, NULL AS pays, SUM(montant) AS montant_total_commande
  FROM resume_commandes
  JOIN clients
    ON (resume_commandes.client_id = clients.client_id)
 GROUP BY type_client

UNION ALL

SELECT NULL, code_pays AS pays, SUM(montant)
  FROM resume_commandes r
  JOIN clients cl
    ON (r.client_id = cl.client_id)
  JOIN contacts co
    ON (cl.contact_id = co.contact_id)
 GROUP BY code_pays;


SELECT clients.client_id, type_client, nos_commandes.*
FROM
(
  SELECT c.numero_commande, c.client_id, SUM(quantite*prix_unitaire) AS montant
  FROM   commandes c
  JOIN   lignes_commandes l
  ON     (c.numero_commande = l.numero_commande)
  GROUP BY 1,2
) AS nos_commandes
INNER JOIN clients
ON    (nos_commandes.client_id = clients.client_id)
WHERE clients.client_id = 6845





