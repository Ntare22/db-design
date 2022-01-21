/*Queries that provide answers to the questions from all projects.*/

SELECT * from animals WHERE name = 'Luna';

/* Find all animals whose name ends in "mon". */

SELECT * from animals WHERE name LIKE '%mon';

/* List the name of all animals born between 2016 and 2019. */

SELECT name from animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';

/* List the name of all animals that are neutered and have less than 3 escape attempts. */

SELECT name from animals WHERE neutered IS true AND escape_attempts < 3;

/* List date of birth of all animals named either "Agumon" or "Pikachu". */

SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');

/* List name and escape attempts of animals that weigh more than 10.5kg */

SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;

/* Find all animals that are neutered. */

SELECT * from animals WHERE neutered IS true;

/* Find all animals not named Gabumon. */

SELECT * from animals WHERE name != 'Gabumon';

/* Find all animals with a weight between 10.4kg and 17.3kg */

SELECT * from animals WHERE weight_kg BETWEEN 10.4 AND 17.3;


/*Transactions*/
BEGIN;
UPDATE animals SET species = 'unspecified';
SELECT species from animals;
ROLLBACK;
SELECT species from animals;

BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
SELECT species from animals;
COMMIT;
SELECT species from animals;

BEGIN;
DELETE FROM animals;
SELECT * from animals;
ROLLBACK;
SELECT * from animals;

BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT SP1;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO SP1;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
SELECT * from animals;
COMMIT;
SELECT * from animals;


SELECT COUNT(*) FROM animals;

SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;

SELECT AVG(weight_kg) FROM animals;

SELECT neutered, AVG(escape_attempts) FROM animals GROUP BY neutered;

SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;

SELECT species, AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species; 

SELECT animals.name FROM animals INNER JOIN owners ON animals.owner_id = owners.id WHERE owners.full_name = 'Melody Pond';

SELECT animals.name FROM species INNER JOIN animals ON species.id = animals.species_id WHERE species.name = 'Pokemon';

SELECT full_name AS owner, name as animal FROM owners LEFT JOIN animals ON owners.id = animals.owner_id;

SELECT species.name AS species, COUNT(*) FROM species 
INNER JOIN animals ON species.id = animals.species_id
GROUP BY species.name;

SELECT animals.name FROM animals INNER JOIN species ON animals.species_id = species.id
INNER JOIN owners ON animals.owner_id = owners.id
WHERE species.name = 'Digimon' AND owners.full_name = 'Jennifer Orwell';

SELECT animals.name FROM animals INNER JOIN owners ON animals.owner_id = owners.id
WHERE animals.escape_attempts = 0 AND owners.full_name = 'Dean Winchester';

SELECT owners.full_name, COUNT(animals.name) AS animals FROM owners INNER JOIN animals ON owners.id = animals.owner_id
GROUP BY owners.full_name
HAVING COUNT(animals.name) = (
  SELECT MAX(animals)
  FROM (
    SELECT owners.full_name, COUNT(animals.name) AS animals
    FROM owners INNER JOIN animals ON owners.id = animals.owner_id
    GROUP BY owners.full_name
  ) AS owners_ranking
);

SELECT a.name, visit_date FROM vets v INNER JOIN visits vi ON v.id = vi.vets_id
INNER JOIN animals a ON a.id = vi.animals_id
WHERE v.name = 'William Tatcher'
ORDER BY visit_date DESC
LIMIT 1;

SELECT DISTINCT v.name, COUNT(a.name) FROM vets v INNER JOIN visits vi ON v.id = vi.vets_id
INNER JOIN animals a ON a.id = vi.animals_id
WHERE v.name = 'Stephanie Mendez'
GROUP BY v.name;

SELECT v.name vet, s.name specialty FROM vets v LEFT JOIN specializations sp ON v.id = sp.vets_id
LEFT JOIN species s ON s.id = sp.species_id;


SELECT a.name, visit_date FROM animals a INNER JOIN visits vi ON a.id = vi.animals_id
INNER JOIN vets v ON v.id = vi.vets_id
WHERE v.name = 'Stephanie Mendez' AND visit_date BETWEEN '2020-04-01' AND '2020-08-30';


SELECT a.name, COUNT(vi.animals_id) visit_count FROM animals a INNER JOIN visits vi ON a.id = vi.animals_id
INNER JOIN vets v ON v.id = vi.vets_id
GROUP BY a.name
ORDER BY COUNT(vi.animals_id) DESC
LIMIT 1;


SELECT a.name, visit_date FROM vets v INNER JOIN visits vi ON v.id = vi.vets_id
INNER JOIN animals a ON a.id = vi.animals_id
WHERE v.name = 'Maisy Smith'
ORDER BY visit_date ASC
LIMIT 1;


SELECT a.name animal_name, a.date_of_birth, a.escape_attempts,
a.neutered, a.weight_kg,
v.name vet, v.age vet_age, v.date_of_graduation vet_date_of_graduation
FROM vets v INNER JOIN visits vi ON v.id = vi.vets_id
INNER JOIN animals a ON a.id = vi.animals_id
ORDER BY vi.visit_date DESC;


SELECT v.name vet, COUNT(a.id) FROM visits vi INNER JOIN vets v ON vi.vets_id = v.id
LEFT JOIN specializations sp ON v.id = sp.vets_id
INNER JOIN animals a ON vi.animals_id = a.id
WHERE sp.species_id != a.species_id
OR sp.species_id IS NULL
GROUP BY v.name
LIMIT 1;


SELECT s.name specialty, COUNT(visit_date) FROM vets v INNER JOIN visits vi ON v.id = vi.vets_id
INNER JOIN animals a ON a.id = vi.animals_id
INNER JOIN species s ON a.species_id = s.id
WHERE v.name = 'Maisy Smith'
GROUP BY s.name
LIMIT 1;

