-- psql --username=freecodecamp --dbname=periodic_table

-- 1) Renombrar columnas
ALTER TABLE properties RENAME COLUMN weight TO atomic_mass;
ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius;
ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius;

-- 2) Restricciones NOT NULL y UNIQUE
ALTER TABLE properties ALTER COLUMN melting_point_celsius SET NOT NULL;
ALTER TABLE properties ALTER COLUMN boiling_point_celsius SET NOT NULL;
ALTER TABLE elements ADD UNIQUE(symbol);
ALTER TABLE elements ADD UNIQUE(name);
ALTER TABLE elements ALTER COLUMN symbol SET NOT NULL;
ALTER TABLE elements ALTER COLUMN name SET NOT NULL;

-- 3) Borrar el elemento inexistente 1000 (primero en properties, luego en elements)
DELETE FROM properties WHERE atomic_number = 1000;
DELETE FROM elements WHERE atomic_number = 1000;

-- 4) atomic_number de properties como clave foránea
ALTER TABLE properties ADD FOREIGN KEY(atomic_number) REFERENCES elements(atomic_number);

-- 5) Tabla types y columna type_id
CREATE TABLE types (
  type_id INT PRIMARY KEY,
  type    VARCHAR(20) NOT NULL
);
INSERT INTO types(type_id, type) VALUES (1, 'metal'), (2, 'metalloid'), (3, 'nonmetal');

ALTER TABLE properties ADD COLUMN type_id INT;
UPDATE properties SET type_id = (SELECT type_id FROM types WHERE types.type = properties.type);
ALTER TABLE properties ALTER COLUMN type_id SET NOT NULL;
ALTER TABLE properties ADD FOREIGN KEY(type_id) REFERENCES types(type_id);

-- 6) Primera letra del símbolo en mayúscula
UPDATE elements SET symbol = INITCAP(symbol);

-- 7) atomic_mass como DECIMAL y sin ceros sobrantes
ALTER TABLE properties ALTER COLUMN atomic_mass TYPE DECIMAL;
UPDATE properties SET atomic_mass = CAST(TRIM(TRAILING '0' FROM atomic_mass::TEXT) AS DECIMAL);

-- 8) Agregar Flúor (9) y Neón (10)
INSERT INTO elements(atomic_number, symbol, name) VALUES (9, 'F', 'Fluorine'), (10, 'Ne', 'Neon');
INSERT INTO properties(atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id)
VALUES (9, 18.998, -220, -188.1, 3), (10, 20.18, -248.6, -246.1, 3);

-- 9) Quitar la columna type (ya se usa type_id)
ALTER TABLE properties DROP COLUMN type;
