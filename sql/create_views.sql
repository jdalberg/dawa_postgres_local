DROP VIEW IF EXISTS adresser CASCADE;
CREATE OR REPLACE VIEW adresser AS
  SELECT
    A.id as a_id,
    A.oprettet as e_oprettet,
    A.ikrafttrædelsesdato as e_ikrafttrædelsesdato,
    A.ændret as e_ændret,
    V.navn as gade,
    V.adresseringsnavn,
    P.navn as by,
    A.etage,
    A.dør,
    AA.postnr,
    AA.husnr,
    AA.supplerendebynavn,
    AA.supplerendebynavn_dagi_id,
    AA.etrs89koordinat_øst::double precision AS øst,
    AA.etrs89koordinat_nord::double precision AS nord,
    AA.højde,
    AA.adgangspunktid,
    AA.nøjagtighed,
    AA.tekniskstandard,
    AA.tekstretning,
    '100m_' || (floor(AA.etrs89koordinat_nord / 100))::text || '_' || (floor(AA.etrs89koordinat_øst / 100))::text as ddkn_m100,
    '1km_' || (floor(AA.etrs89koordinat_nord / 1000))::text || '_' || (floor(AA.etrs89koordinat_øst / 1000))::text as ddkn_km1,
    '10km_' || (floor(AA.etrs89koordinat_nord / 10000))::text || '_' || (floor(AA.etrs89koordinat_øst / 10000))::text as ddkn_km10,
    AA.adressepunktændringsdato

  FROM adresse A
    LEFT JOIN adgangsadresse AA ON A.adgangsadresseid = AA.id
    LEFT JOIN vejstykke V ON AA.vejkode = V.kode AND AA.kommunekode = V.kommunekode
    LEFT JOIN postnummer P ON AA.postnr = P.nr;