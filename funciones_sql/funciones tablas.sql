CREATE TABLE jugador
(
  id_jugador character varying(25) NOT NULL,
  nombre character varying(25) NOT NULL,
  apellido character varying(25) NOT NULL,
  email character varying(25) NOT NULL,
  "contraseña" character varying(10) NOT NULL,
  saldo integer NOT NULL DEFAULT 0,
  exp integer NOT NULL DEFAULT 0,
  sexo character varying(10) NOT NULL,
  id_clan integer,
  CONSTRAINT jugador_pkey PRIMARY KEY (id_jugador),
  CONSTRAINT jugador_id_clan_fkey FOREIGN KEY (id_clan)
      REFERENCES clan (id_clan) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT jugador_exp_check CHECK (exp < 101),
  CONSTRAINT jugador_saldo_check CHECK (saldo < 10001)
)

CREATE TABLE aldea
(
  id_aldea serial NOT NULL,
  id_jugador character varying(25),
  CONSTRAINT aldea_pkey PRIMARY KEY (id_aldea),
  CONSTRAINT aldea_id_jugador_fkey FOREIGN KEY (id_jugador)
      REFERENCES jugador (id_jugador) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)

CREATE TABLE edificio_jugador
(
  id_edificio_jugador serial PRIMARY KEY,
  nivel_edificio int CHECK(nivel_edificio<100) default 1,
  id_edificio serial REFERENCES edificio(id_edificio),
  id_aldea serial REFERENCES aldea(id_aldea)
);