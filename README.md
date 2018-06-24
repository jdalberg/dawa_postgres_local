# dawa_postgres_local
Import af eksporterede adresse data fra DAWA til lokal posgresql base

## Opret database
Database oprettes med [Create DB](https://github.com/jdalberg/dawa_postgres_local/sql/createdb.sql) som er modificeret fra [DAWAs egen](https://github.com/DanmarksAdresser/Dawa/blob/master/psql/createdb/createdb.sql)
Hvis du hellere vil have et andet db navn en dawa_local, så kan du rette i createdb.sql inden du kører igennem psql med 

```
psql -U whateveruser -h localhost -d "postgress" < createdb.sql
```

## Opret tabeller
Tabeller oprettes med [CreateAdrTables.sql](https://github.com/DanmarksAdresser/Dawa/blob/master/psql/createdb/create_adr_tables.sql)
```
psql -U whateveruser dawa_local < create_adr_tables.sql
```

## Opret views
Views oprettes med [CreateViews.sql](https://github.com/DanmarksAdresser/Dawa/blob/master/psql/createdb/create_views.sql)
```
psql -U whateveruser dawa_local < create_views.sql
```

## Import af data
create_adr_tables oprettet 4 tabeller navngivet efter de entiteter der bliver eksponeret at DAWA api. Data trækkes ud af DAWA med 

```
curl "https://dawa.aws.dk/replikering/udtraek?entitet=postnummer&format=csv" > postnummer.csv
curl "https://dawa.aws.dk/replikering/udtraek?entitet=vejstykke&format=csv" > vejstykke.csv
curl "https://dawa.aws.dk/replikering/udtraek?entitet=adresse&format=csv" > adresse.csv
curl "https://dawa.aws.dk/replikering/udtraek?entitet=adgangsadresse&format=csv" > adgangsadresse.csv
```

### Rensning af rådata
For at få data i databasen skal de lige vaskes lidt først, specielt oplevede jeg at adresse har "bad entries" entries som violated NOT NULL clauses i create statements. Hvis ikke før
så opdager du dem når du importerer dem som nedenfor. Det er typisk entries med "null,null,null.." osv i. Det var ca. 3 i mine rådata.

Derudover skal postnummer.csv have lidt love for at lave storkunde boolean fra "missing" til "0".

```
sed -i -e 's/,^M$/,0/' postnummer.csv
```
hvor ^M er ctrl-v ctrl-m som du sikkert ved :).

### Import med COPY
```
psql -U whateveruser dawa_local

dawa_local=> \COPY adgangsadresse(id,status,oprettet,ændret,ikrafttrædelsesdato,kommunekode,vejkode,husnr,supplerendebynavn,postnr,ejerlavkode,matrikelnr,esrejendomsnr,etrs89koordinat_øst,etrs89koordinat_nord,nøjagtighed,kilde,husnummerkilde,tekniskstandard,tekstretning,adressepunktændringsdato,esdhreference,journalnummer,højde,adgangspunktid,supplerendebynavn_dagi_id,vejpunkt_id,navngivenvej_id) FROM 'adgangsadresse.csv' DELIMITER ',' HEADER CSV
dawa_local=> \COPY adresse(id,status,oprettet,ændret,ikrafttrædelsesdato,adgangsadresseid,etage,dør,kilde,esdhreference,journalnummer) FROM 'adresse.csv' DELIMITER ',' HEADER CSV
dawa_local=> \COPY vejstykke(kommunekode,kode,oprettet,ændret,navn,adresseringsnavn,navngivenvej_id) FROM 'vejstykke.csv' DELIMITER ',' HEADER CSV
dawa_local=> \COPY postnummer(nr,navn,stormodtager) FROM 'postnummer.csv' DELIMITER ',' HEADER CSV

```

Derefter kan viewet "adresser" bruges til at søge med, f.eks.

```
dawa_local=> \x on
Expanded display is on.
dawa_local=> select * from adresser where gade = 'Rentemestervej' and husnr = '8' and postnr = 2400 and etage = '1';
-[ RECORD 1 ]-------------+-------------------------------------
a_id                      | 0a3f50a0-4661-32b8-e044-0003ba298018
e_oprettet                | 2000-02-05 20:31:05
e_ikrafttrædelsesdato     | 2000-02-05 00:00:00
e_ændret                  | 2000-02-05 20:31:05
gade                      | Rentemestervej
adresseringsnavn          | Rentemestervej
by                        | København NV
etage                     | 1
dør                       | 
postnr                    | 2400
husnr                     | 8
supplerendebynavn         | 
supplerendebynavn_dagi_id | 
øst                       | 722125.86
nord                      | 6178892.29
højde                     | 8.2
adgangspunktid            | 0a3f507a-e179-32b8-e044-0003ba298018
nøjagtighed               | A
tekniskstandard           | TD
tekstretning              | 200.00
ddkn_m100                 | 100m_61788_7221
ddkn_km1                  | 1km_6178_722
ddkn_km10                 | 10km_617_72
adressepunktændringsdato  | 2002-04-05 00:00:00
```
