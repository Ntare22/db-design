/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
  id INT GENERATED ALWAYS AS IDENTITY,
  name VARCHAR NOT NULL,
  date_of_birth DATE NOT NULL,
  escape_attempts INT,
  neutered BOOLEAN,
  weight_kg DECIMAL,
  PRIMARY KEY(id)
);

ALTER TABLE animals ADD COLUMN species VARCHAR;

CREATE TABLE owners (
  id INT GENERATED ALWAYS AS IDENTITY,
  full_name VARCHAR NOT NULL,
  age INT,
  PRIMARY KEY(id)
);

CREATE TABLE species (
  id INT GENERATED ALWAYS AS IDENTITY,
  name VARCHAR NOT NULL,
  PRIMARY KEY(id)
);

ALTER TABLE animals DROP COLUMN species;

ALTER TABLE animals
ADD COLUMN species_id INT;
ALTER TABLE animals
ADD CONSTRAINT species
FOREIGN KEY (species_id)
REFERENCES species (id);

ALTER TABLE animals
ADD COLUMN owner_id INT;
ALTER TABLE animals
ADD CONSTRAINT owner
FOREIGN KEY (owner_id)
REFERENCES owners (id);