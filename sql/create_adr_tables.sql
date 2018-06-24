
DROP TABLE IF EXISTS adgangsadresse CASCADE;
CREATE TABLE adgangsadresse (
  id uuid NOT NULL PRIMARY KEY,
  status SMALLINT NOT NULL,
  kommunekode INTEGER NOT NULL,
  vejkode INTEGER NOT NULL,
  husnr VARCHAR(20),
  supplerendebynavn text NULL,
  postnr INTEGER NULL,
  ejerlavkode INTEGER,
  matrikelnr text NULL,
  esrejendomsnr integer NULL,
  oprettet timestamp,
  ændret timestamp,
  ikrafttrædelsesdato timestamp,
  adgangspunktid uuid,
  etrs89koordinat_øst double precision NULL,
  etrs89koordinat_nord double precision NULL,
  nøjagtighed CHAR(1) NULL,
  kilde smallint NULL,
  husnummerkilde smallint,
  tekniskstandard CHAR(2) NULL,
  tekstretning numeric(5,2) NULL,
  adressepunktændringsdato timestamp NULL,
  esdhreference text,
  journalnummer text,
  højde double precision NULL,
  navngivenvej_id uuid,
  supplerendebynavn_dagi_id integer,
  adressepunkt_id uuid,
  vejpunkt_id uuid
);


CREATE INDEX ON adgangsadresse(kommunekode, vejkode, postnr);
CREATE INDEX ON adgangsadresse(postnr, kommunekode);
CREATE INDEX ON adgangsadresse(postnr, id);
CREATE INDEX ON adgangsadresse(supplerendebynavn, kommunekode, postnr);
CREATE INDEX ON adgangsadresse(matrikelnr);
CREATE INDEX ON adgangsadresse(husnr, id);
CREATE INDEX ON adgangsadresse(esrejendomsnr);
CREATE INDEX ON adgangsadresse(nøjagtighed, id);
CREATE INDEX ON adgangsadresse(navngivenvej_id, postnr);
CREATE INDEX ON adgangsadresse(vejkode,postnr);
CREATE INDEX ON adgangsadresse(vejpunkt_id);
CREATE INDEX ON adgangsadresse(supplerendebynavn_dagi_id);

DROP TABLE IF EXISTS adresse;
CREATE TABLE adresse(
  id UUID PRIMARY KEY,
  status SMALLINT NOT NULL,
  adgangsadresseid UUID NOT NULL,
  oprettet timestamp,
  ikrafttrædelsesdato timestamp,
  ændret timestamp,
  etage VARCHAR(3),
  dør VARCHAR(4),
  kilde smallint,
  esdhreference text,
  journalnummer text
);

CREATE INDEX ON adresse(adgangsadresseid);
CREATE INDEX ON adresse(etage, id);
CREATE INDEX ON adresse(dør, id);


DROP TABLE IF EXISTS vejstykke CASCADE;
CREATE TABLE IF NOT EXISTS vejstykke (
  kommunekode integer NOT NULL,
  kode integer NOT NULL,
  oprettet timestamp,
  ændret timestamp,
  navn VARCHAR(255) NOT NULL,
  adresseringsnavn VARCHAR(255),
  navngivenvej_id uuid,
  PRIMARY KEY(kommunekode, kode)
);

CREATE INDEX ON vejstykke(kode);
CREATE INDEX ON vejstykke(navn);
CREATE INDEX ON vejstykke(navngivenvej_id);



DROP TABLE IF EXISTS postnummer CASCADE;
CREATE TABLE IF NOT EXISTS postnummer (
  nr integer NOT NULL PRIMARY KEY,
  navn VARCHAR(20) NOT NULL,
  stormodtager boolean NOT NULL DEFAULT false
);

CREATE INDEX ON postnummer(navn);

