
WITH RECURSIVE suite AS (
SELECT 1 AS valeur
UNION ALL
SELECT valeur + 1
  FROM suite
 WHERE valeur < 10
)
SELECT * FROM suite;



WITH RECURSIVE parcours_menu AS (
SELECT menu_id, libelle, parent_id,
       libelle AS arborescence
  FROM entrees_menu
 WHERE libelle = 'Terminal'
   AND parent_id IS NULL
UNION ALL
SELECT menu.menu_id, menu.libelle, menu.parent_id,
       arborescence || '/' || menu.libelle
  FROM entrees_menu menu
  JOIN parcours_menu parent
    ON (menu.parent_id = parent.menu_id)
)
SELECT * FROM parcours_menu;



WITH ventes_regionales AS (
        SELECT region, SUM(montant) AS ventes_totales
        FROM commandes
        GROUP BY region
     ), meilleures_regions AS (
        SELECT region
        FROM ventes_regionales
        WHERE ventes_totales > (SELECT SUM(ventes_totales)/10 FROM ventes_regionales)
     )


SELECT region,
       produit,
       SUM(quantite) AS unites_produit,
       SUM(montant) AS ventes_produit
FROM commandes
WHERE region IN (SELECT region FROM meilleures_regions)
GROUP BY region, produit;



WITH RECURSIVE parcourt_graphe(id, lien, donnee, profondeur) AS (
        SELECT g.id, g.lien, g.donnee, 1
        FROM graphe g
      UNION ALL
        SELECT g.id, g.lien, g.donnee, sg.profondeur + 1
        FROM graphe g, parcourt_graphe sg
        WHERE g.id = sg.lien
)
SELECT * FROM parcourt_graphe;




WITH tree (donnee, id, level, pathstr, nomcontact)                        
AS (SELECT compte.nom, compte.idcompte, 0, CAST('' AS NVARCHAR(MAX)), contact.nom         
    FROM compte LEFT JOIN contact on compte.idcompte = contact.idcompte                   
    WHERE compte.idcompte = @Identifiant
    UNION ALL                               
    SELECT V.nom, V.idcompte, t.level + 1, t.pathstr + V.nom, contact.nom
    FROM   compte V INNER JOIN contact on V.idcompte = contact.idcompte                  
           INNER JOIN tree t 
                 ON t.id = V.idcompteparent)
SELECT DISTINCT donnee, id, level, pathstr, nomcontact
FROM   tree
ORDER  BY pathstr, id

