--
-- PostgreSQL database cluster dump
--

-- Started on 2015-06-18 22:56:54

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION PASSWORD 'md5eda177c892c7d8aaefeb40e131919a45';






--
-- Database creation
--

CREATE DATABASE "ClashOfCrews" WITH TEMPLATE = template0 OWNER = postgres;
REVOKE ALL ON DATABASE template1 FROM PUBLIC;
REVOKE ALL ON DATABASE template1 FROM postgres;
GRANT ALL ON DATABASE template1 TO postgres;
GRANT CONNECT ON DATABASE template1 TO PUBLIC;


\connect "ClashOfCrews"

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.2
-- Dumped by pg_dump version 9.4.2
-- Started on 2015-06-18 22:56:54

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 2153 (class 1262 OID 16393)
-- Dependencies: 2152
-- Name: ClashOfCrews; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE "ClashOfCrews" IS 'Base de datos de Proyecto de Base de Datos INF PUCV';


--
-- TOC entry 191 (class 3079 OID 11855)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2156 (class 0 OID 0)
-- Dependencies: 191
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- TOC entry 210 (class 1255 OID 16580)
-- Name: crear_aldea(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION crear_aldea(id text) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$BEGIN 

INSERT INTO aldea(id_jugador) VALUES ($1);
RETURN TRUE;

END;

$_$;


ALTER FUNCTION public.crear_aldea(id text) OWNER TO postgres;

--
-- TOC entry 228 (class 1255 OID 16697)
-- Name: crear_aldea_inicial(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION crear_aldea_inicial() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN 
	INSERT INTO aldea (id_jugador) VALUES (NEW.id_jugador);
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.crear_aldea_inicial() OWNER TO postgres;

--
-- TOC entry 232 (class 1255 OID 16708)
-- Name: crear_clan(text, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION crear_clan(nombre text, cantidad integer, experiencia integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$ 
BEGIN 
	INSERT INTO clan(nombre,cant_miembros,experiencia)values($1,$2,$3);
	RETURN TRUE;
END;
$_$;


ALTER FUNCTION public.crear_clan(nombre text, cantidad integer, experiencia integer) OWNER TO postgres;

--
-- TOC entry 227 (class 1255 OID 16696)
-- Name: crear_edificio(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION crear_edificio(aldea integer, edificio integer, nivel integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
BEGIN 
	INSERT INTO edificio_jugador (id_aldea,id_edificio,nivel_edificio) VALUES ($1,$2,$3);
    RETURN TRUE;
END;
$_$;


ALTER FUNCTION public.crear_edificio(aldea integer, edificio integer, nivel integer) OWNER TO postgres;

--
-- TOC entry 226 (class 1255 OID 16694)
-- Name: crear_edificio_inicial(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION crear_edificio_inicial() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN 
	INSERT INTO edificio_jugador (id_aldea,id_edificio,nivel_edificio) VALUES (NEW.id_aldea,2,1);
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.crear_edificio_inicial() OWNER TO postgres;

--
-- TOC entry 209 (class 1255 OID 16567)
-- Name: crear_jugador(text, text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION crear_jugador(id text, nombre text, apellido text, sexo text, mail text, pass text) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$BEGIN

	INSERT INTO jugador(id_jugador,nombre,apellido,sexo,email,contraseña) VALUES ($1,$2,$3,$4,$5,$6);
	RETURN TRUE;
END;
$_$;


ALTER FUNCTION public.crear_jugador(id text, nombre text, apellido text, sexo text, mail text, pass text) OWNER TO postgres;

--
-- TOC entry 216 (class 1255 OID 16674)
-- Name: crear_unidad(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION crear_unidad(idaldea integer, idunidad integer, cantidad integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$DECLARE
repetido BOOLEAN;
cantNueva INTEGER;
BEGIN
        SELECT (id_unidad = idUnidad) INTO repetido FROM detalle_unidades
        WHERE id_aldea = $1;
        IF repetido THEN 
            SELECT cant INTO cantNueva FROM detalle_unidades WHERE id_unidad = idUnidad;
            UPDATE detalle_unidades SET cant = cantNueva + $3 WHERE id_unidad = idUnidad;
            RETURN TRUE;
        ELSE
            INSERT INTO detalle_unidades (id_aldea,id_unidad,cant) VALUES ($1,$2,$3);
            RETURN TRUE;
        END IF;
	  RETURN FALSE;
END;
$_$;


ALTER FUNCTION public.crear_unidad(idaldea integer, idunidad integer, cantidad integer) OWNER TO postgres;

--
-- TOC entry 225 (class 1255 OID 16692)
-- Name: crear_unidades_iniciales(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION crear_unidades_iniciales() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
        INSERT INTO detalle_unidades (id_aldea,id_unidad,cant) VALUES (NEW.id_aldea,3,2);
        RETURN NEW;
END;
$$;


ALTER FUNCTION public.crear_unidades_iniciales() OWNER TO postgres;

--
-- TOC entry 234 (class 1255 OID 24879)
-- Name: eliminar_clan(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION eliminar_clan(id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
	BEGIN
		DELETE FROM clan WHERE id_clan = $1;
		RETURN TRUE;
	END;
$_$;


ALTER FUNCTION public.eliminar_clan(id integer) OWNER TO postgres;

--
-- TOC entry 236 (class 1255 OID 24881)
-- Name: eliminar_jugador_de_clan(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION eliminar_jugador_de_clan(id text) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$	BEGIN
		UPDATE jugador SET id_clan = null WHERE id_jugador = $1;
		RETURN TRUE;
	END;
$_$;


ALTER FUNCTION public.eliminar_jugador_de_clan(id text) OWNER TO postgres;

--
-- TOC entry 221 (class 1255 OID 24871)
-- Name: modificar_exp_clan(integer, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION modificar_exp_clan(dato integer, clan text) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
	BEGIN
		UPDATE clan SET experiencia = $1 
		WHERE nombre = $2;
		RETURN TRUE;
	END;
$_$;


ALTER FUNCTION public.modificar_exp_clan(dato integer, clan text) OWNER TO postgres;

--
-- TOC entry 223 (class 1255 OID 24874)
-- Name: modificar_exp_jugador(integer, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION modificar_exp_jugador(dato integer, id text) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
	BEGIN
		UPDATE jugador SET exp = $1 WHERE id_jugador = $2;
		RETURN TRUE;
	END;
$_$;


ALTER FUNCTION public.modificar_exp_jugador(dato integer, id text) OWNER TO postgres;

--
-- TOC entry 231 (class 1255 OID 16710)
-- Name: modificar_id_clan(integer, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION modificar_id_clan(clan integer, jugador text) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
	BEGIN
		UPDATE jugador SET id_clan = $1 
		WHERE id_jugador = $2;
		RETURN TRUE;
	END;
$_$;


ALTER FUNCTION public.modificar_id_clan(clan integer, jugador text) OWNER TO postgres;

--
-- TOC entry 235 (class 1255 OID 24880)
-- Name: modificar_jugador(text, text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION modificar_jugador(nom text, apell text, genero text, mail text, pass text, id text) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$	BEGIN
		UPDATE jugador SET nombre = $1 WHERE id_jugador = $6;
		UPDATE jugador SET apellido = $2 WHERE id_jugador = $6;
		UPDATE jugador SET email = $3 WHERE id_jugador = $6;
		UPDATE jugador SET sexo = $4 WHERE id_jugador = $6;
		UPDATE jugador SET contraseña = $5 WHERE id_jugador = $6;
		RETURN TRUE;
	END;
$_$;


ALTER FUNCTION public.modificar_jugador(nom text, apell text, genero text, mail text, pass text, id text) OWNER TO postgres;

--
-- TOC entry 238 (class 1255 OID 24883)
-- Name: modificar_nivel_edificio(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION modificar_nivel_edificio(dato integer, id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
	BEGIN
		UPDATE edificio_jugador SET nivel_edificio = $1 WHERE id_edificio_jugador = $2;
		RETURN TRUE;
	END;
$_$;


ALTER FUNCTION public.modificar_nivel_edificio(dato integer, id integer) OWNER TO postgres;

--
-- TOC entry 206 (class 1255 OID 16573)
-- Name: modificar_pass(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION modificar_pass(dato text, id text) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
	BEGIN
		IF ($1 = '') THEN --Valida por si el campo es recibido vacio
			RETURN FALSE;
		ELSE
			UPDATE jugador SET contraseña = $1 
			WHERE id_jugador = $2;
			RETURN TRUE;
		END IF;
	END;
$_$;


ALTER FUNCTION public.modificar_pass(dato text, id text) OWNER TO postgres;

--
-- TOC entry 208 (class 1255 OID 16578)
-- Name: modificar_saldo(integer, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION modificar_saldo(dato integer, id text) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$	BEGIN
		UPDATE jugador SET saldo = $1 
		WHERE id_jugador = $2;
		RETURN TRUE;
	END;
$_$;


ALTER FUNCTION public.modificar_saldo(dato integer, id text) OWNER TO postgres;

--
-- TOC entry 224 (class 1255 OID 24875)
-- Name: obtener_cant_miembros_clan(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION obtener_cant_miembros_clan(id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
BEGIN
	RETURN (SELECT cant_miembros FROM clan WHERE id_clan=$1);
END;
$_$;


ALTER FUNCTION public.obtener_cant_miembros_clan(id integer) OWNER TO postgres;

--
-- TOC entry 214 (class 1255 OID 16670)
-- Name: obtener_costo_edificio(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION obtener_costo_edificio(id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
BEGIN
	RETURN (SELECT costo_edificio FROM edificio WHERE id_edificio=$1);
END;
$_$;


ALTER FUNCTION public.obtener_costo_edificio(id integer) OWNER TO postgres;

--
-- TOC entry 215 (class 1255 OID 16671)
-- Name: obtener_costo_unidad(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION obtener_costo_unidad(id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
BEGIN
	RETURN (SELECT costo FROM unidad WHERE id_unidad=$1);
END;
$_$;


ALTER FUNCTION public.obtener_costo_unidad(id integer) OWNER TO postgres;

--
-- TOC entry 233 (class 1255 OID 24870)
-- Name: obtener_exp_clan(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION obtener_exp_clan(name text) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
BEGIN
	RETURN (SELECT experiencia FROM clan WHERE nombre=$1);
END;
$_$;


ALTER FUNCTION public.obtener_exp_clan(name text) OWNER TO postgres;

--
-- TOC entry 220 (class 1255 OID 16683)
-- Name: obtener_expbase_edificios(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION obtener_expbase_edificios(id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
BEGIN
	RETURN (SELECT experiencia_base FROM edificio WHERE id_edificio=$1);
END;
$_$;


ALTER FUNCTION public.obtener_expbase_edificios(id integer) OWNER TO postgres;

--
-- TOC entry 211 (class 1255 OID 16663)
-- Name: obtener_id_aldea(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION obtener_id_aldea(id text) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
BEGIN
	RETURN (SELECT id_aldea FROM aldea WHERE id_jugador=$1);
END;
$_$;


ALTER FUNCTION public.obtener_id_aldea(id text) OWNER TO postgres;

--
-- TOC entry 230 (class 1255 OID 16709)
-- Name: obtener_id_clan(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION obtener_id_clan(name text) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
BEGIN
	RETURN (SELECT id_clan FROM clan WHERE nombre=$1);
END;
$_$;


ALTER FUNCTION public.obtener_id_clan(name text) OWNER TO postgres;

--
-- TOC entry 237 (class 1255 OID 24884)
-- Name: obtener_nivel_edificio(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION obtener_nivel_edificio(id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
BEGIN
	RETURN (SELECT nivel_edificio FROM edificio_jugador WHERE id_edificio_jugador = $1);
END;
$_$;


ALTER FUNCTION public.obtener_nivel_edificio(id integer) OWNER TO postgres;

--
-- TOC entry 222 (class 1255 OID 24873)
-- Name: obtener_nombre_clan(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION obtener_nombre_clan(id integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$
BEGIN
	RETURN (SELECT nombre FROM clan WHERE id_clan=$1);
END;
$_$;


ALTER FUNCTION public.obtener_nombre_clan(id integer) OWNER TO postgres;

--
-- TOC entry 213 (class 1255 OID 16669)
-- Name: obtener_nombre_edificio(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION obtener_nombre_edificio(idedificio integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$
BEGIN 

RETURN(SELECT nombre_edificio FROM edificio WHERE id_edificio=$1);

END;
$_$;


ALTER FUNCTION public.obtener_nombre_edificio(idedificio integer) OWNER TO postgres;

--
-- TOC entry 212 (class 1255 OID 16666)
-- Name: obtener_nombre_unidad(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION obtener_nombre_unidad(idunidad integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$
BEGIN 

RETURN(SELECT nombre FROM unidad WHERE id_unidad=$1);

END; 
$_$;


ALTER FUNCTION public.obtener_nombre_unidad(idunidad integer) OWNER TO postgres;

--
-- TOC entry 207 (class 1255 OID 16577)
-- Name: obtener_saldo(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION obtener_saldo(id text) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
BEGIN
	RETURN (SELECT saldo FROM jugador WHERE id_jugador=$1);
END;
$_$;


ALTER FUNCTION public.obtener_saldo(id text) OWNER TO postgres;

--
-- TOC entry 219 (class 1255 OID 16682)
-- Name: registrar_ataque(date, text, text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION registrar_ataque(fech date, atacante text, victima text, cantidad integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
BEGIN 
INSERT INTO ataque (fecha,id_atacante,id_victima,cant_unidades) VALUES($1,$2,$3,$4);
RETURN TRUE;
END;
$_$;


ALTER FUNCTION public.registrar_ataque(fech date, atacante text, victima text, cantidad integer) OWNER TO postgres;

--
-- TOC entry 217 (class 1255 OID 16677)
-- Name: registrar_mensaje(text, date, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION registrar_mensaje(msj text, fech date, emisor text, receptor text) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
BEGIN 
	INSERT INTO msj (mensaje,fecha,id_emisor,id_receptor) VALUES ($1,$2,$3,$4);
	RETURN TRUE;
END;
$_$;


ALTER FUNCTION public.registrar_mensaje(msj text, fech date, emisor text, receptor text) OWNER TO postgres;

--
-- TOC entry 218 (class 1255 OID 16676)
-- Name: registrar_transaccion(date, integer, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION registrar_transaccion(fech date, costo integer, tipo text, id text) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$BEGIN 
	INSERT INTO transaccion (fecha,monto,tipo,id_jugador) VALUES ($1,$2,$3,$4);
	RETURN TRUE;
END;
$_$;


ALTER FUNCTION public.registrar_transaccion(fech date, costo integer, tipo text, id text) OWNER TO postgres;

--
-- TOC entry 229 (class 1255 OID 16700)
-- Name: verificar_clan(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION verificar_clan(name text) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
	BEGIN
		IF(select nombre FROM clan WHERE nombre=$1)=$1 THEN
			RETURN TRUE;
		ELSE
			RETURN FALSE;
		END IF;
	END;
$_$;


ALTER FUNCTION public.verificar_clan(name text) OWNER TO postgres;

--
-- TOC entry 205 (class 1255 OID 16409)
-- Name: verificar_email(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION verificar_email(mail text) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$	BEGIN
		IF(select email FROM jugador WHERE email=$1)=$1 THEN
			RETURN TRUE;
		ELSE
			RETURN FALSE;
		END IF;
	END;$_$;


ALTER FUNCTION public.verificar_email(mail text) OWNER TO postgres;

--
-- TOC entry 204 (class 1255 OID 16478)
-- Name: verificar_usuario(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION verificar_usuario(id text, pass text) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
BEGIN
		IF (select contraseña FROM jugador WHERE id_jugador=$1)=$2 THEN
			RETURN TRUE;
		ELSE
			RETURN FALSE;
		END IF;
END;
$_$;


ALTER FUNCTION public.verificar_usuario(id text, pass text) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 182 (class 1259 OID 16520)
-- Name: aldea; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE aldea (
    id_aldea integer NOT NULL,
    id_jugador character varying(25)
);


ALTER TABLE aldea OWNER TO postgres;

--
-- TOC entry 181 (class 1259 OID 16518)
-- Name: aldea_id_aldea_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE aldea_id_aldea_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE aldea_id_aldea_seq OWNER TO postgres;

--
-- TOC entry 2157 (class 0 OID 0)
-- Dependencies: 181
-- Name: aldea_id_aldea_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE aldea_id_aldea_seq OWNED BY aldea.id_aldea;


--
-- TOC entry 180 (class 1259 OID 16502)
-- Name: ataque; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ataque (
    id_ataque integer NOT NULL,
    cant_unidades integer NOT NULL,
    fecha date NOT NULL,
    id_atacante character varying(25),
    id_victima character varying(25)
);


ALTER TABLE ataque OWNER TO postgres;

--
-- TOC entry 179 (class 1259 OID 16500)
-- Name: ataque_id_ataque_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE ataque_id_ataque_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ataque_id_ataque_seq OWNER TO postgres;

--
-- TOC entry 2158 (class 0 OID 0)
-- Dependencies: 179
-- Name: ataque_id_ataque_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE ataque_id_ataque_seq OWNED BY ataque.id_ataque;


--
-- TOC entry 173 (class 1259 OID 16418)
-- Name: clan; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE clan (
    id_clan integer NOT NULL,
    cant_miembros integer NOT NULL,
    experiencia integer NOT NULL,
    nombre character varying(25) NOT NULL,
    CONSTRAINT clan_experiencia_check CHECK ((experiencia < 5001))
);


ALTER TABLE clan OWNER TO postgres;

--
-- TOC entry 172 (class 1259 OID 16416)
-- Name: clan_id_clan_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE clan_id_clan_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clan_id_clan_seq OWNER TO postgres;

--
-- TOC entry 2159 (class 0 OID 0)
-- Dependencies: 172
-- Name: clan_id_clan_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE clan_id_clan_seq OWNED BY clan.id_clan;


--
-- TOC entry 185 (class 1259 OID 16544)
-- Name: detalle_unidades; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE detalle_unidades (
    id_aldea integer NOT NULL,
    id_unidad integer NOT NULL,
    cant integer DEFAULT 2
);


ALTER TABLE detalle_unidades OWNER TO postgres;

--
-- TOC entry 187 (class 1259 OID 16561)
-- Name: edificio; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE edificio (
    id_edificio integer NOT NULL,
    nombre_edificio character varying(50) NOT NULL,
    costo_edificio integer NOT NULL,
    experiencia_base integer NOT NULL
);


ALTER TABLE edificio OWNER TO postgres;

--
-- TOC entry 186 (class 1259 OID 16559)
-- Name: edificio_id_edificio_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE edificio_id_edificio_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE edificio_id_edificio_seq OWNER TO postgres;

--
-- TOC entry 2160 (class 0 OID 0)
-- Dependencies: 186
-- Name: edificio_id_edificio_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE edificio_id_edificio_seq OWNED BY edificio.id_edificio;


--
-- TOC entry 190 (class 1259 OID 16689)
-- Name: edificio_jugador_id_edificio_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE edificio_jugador_id_edificio_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE edificio_jugador_id_edificio_seq OWNER TO postgres;

--
-- TOC entry 189 (class 1259 OID 16612)
-- Name: edificio_jugador; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE edificio_jugador (
    id_edificio_jugador integer NOT NULL,
    nivel_edificio integer DEFAULT 1 NOT NULL,
    id_edificio integer DEFAULT nextval('edificio_jugador_id_edificio_seq'::regclass) NOT NULL,
    id_aldea integer NOT NULL,
    CONSTRAINT edificio_jugador_nivel_edificio_check CHECK ((nivel_edificio < 100))
);


ALTER TABLE edificio_jugador OWNER TO postgres;

--
-- TOC entry 188 (class 1259 OID 16606)
-- Name: edificio_jugador_id_edificio_jugador_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE edificio_jugador_id_edificio_jugador_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE edificio_jugador_id_edificio_jugador_seq OWNER TO postgres;

--
-- TOC entry 2161 (class 0 OID 0)
-- Dependencies: 188
-- Name: edificio_jugador_id_edificio_jugador_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE edificio_jugador_id_edificio_jugador_seq OWNED BY edificio_jugador.id_edificio_jugador;


--
-- TOC entry 174 (class 1259 OID 16440)
-- Name: jugador; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE jugador (
    id_jugador character varying(25) NOT NULL,
    nombre character varying(25) NOT NULL,
    apellido character varying(25) NOT NULL,
    email character varying(50) NOT NULL,
    "contraseña" character varying(10) NOT NULL,
    saldo integer DEFAULT 10000 NOT NULL,
    exp integer DEFAULT 0 NOT NULL,
    sexo character varying(10) NOT NULL,
    id_clan integer,
    CONSTRAINT jugador_exp_check CHECK ((exp < 101)),
    CONSTRAINT jugador_saldo_check CHECK ((saldo < 100001))
);


ALTER TABLE jugador OWNER TO postgres;

--
-- TOC entry 178 (class 1259 OID 16481)
-- Name: msj; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE msj (
    id_mensaje integer NOT NULL,
    mensaje character varying(5000) NOT NULL,
    fecha date NOT NULL,
    id_emisor character varying(25),
    id_receptor character varying(25)
);


ALTER TABLE msj OWNER TO postgres;

--
-- TOC entry 177 (class 1259 OID 16479)
-- Name: msj_id_mensaje_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE msj_id_mensaje_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE msj_id_mensaje_seq OWNER TO postgres;

--
-- TOC entry 2162 (class 0 OID 0)
-- Dependencies: 177
-- Name: msj_id_mensaje_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE msj_id_mensaje_seq OWNED BY msj.id_mensaje;


--
-- TOC entry 176 (class 1259 OID 16454)
-- Name: transaccion; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE transaccion (
    id_transaccion integer NOT NULL,
    fecha date NOT NULL,
    monto integer NOT NULL,
    tipo character varying(25) NOT NULL,
    id_jugador character varying(25)
);


ALTER TABLE transaccion OWNER TO postgres;

--
-- TOC entry 175 (class 1259 OID 16452)
-- Name: transaccion_id_transaccion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE transaccion_id_transaccion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE transaccion_id_transaccion_seq OWNER TO postgres;

--
-- TOC entry 2163 (class 0 OID 0)
-- Dependencies: 175
-- Name: transaccion_id_transaccion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE transaccion_id_transaccion_seq OWNED BY transaccion.id_transaccion;


--
-- TOC entry 184 (class 1259 OID 16533)
-- Name: unidad; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE unidad (
    id_unidad integer NOT NULL,
    nombre character varying(25) NOT NULL,
    costo integer NOT NULL
);


ALTER TABLE unidad OWNER TO postgres;

--
-- TOC entry 183 (class 1259 OID 16531)
-- Name: unidad_id_unidad_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE unidad_id_unidad_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE unidad_id_unidad_seq OWNER TO postgres;

--
-- TOC entry 2164 (class 0 OID 0)
-- Dependencies: 183
-- Name: unidad_id_unidad_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE unidad_id_unidad_seq OWNED BY unidad.id_unidad;


--
-- TOC entry 1978 (class 2604 OID 16523)
-- Name: id_aldea; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY aldea ALTER COLUMN id_aldea SET DEFAULT nextval('aldea_id_aldea_seq'::regclass);


--
-- TOC entry 1977 (class 2604 OID 16505)
-- Name: id_ataque; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ataque ALTER COLUMN id_ataque SET DEFAULT nextval('ataque_id_ataque_seq'::regclass);


--
-- TOC entry 1969 (class 2604 OID 16421)
-- Name: id_clan; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY clan ALTER COLUMN id_clan SET DEFAULT nextval('clan_id_clan_seq'::regclass);


--
-- TOC entry 1981 (class 2604 OID 16564)
-- Name: id_edificio; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY edificio ALTER COLUMN id_edificio SET DEFAULT nextval('edificio_id_edificio_seq'::regclass);


--
-- TOC entry 1982 (class 2604 OID 16615)
-- Name: id_edificio_jugador; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY edificio_jugador ALTER COLUMN id_edificio_jugador SET DEFAULT nextval('edificio_jugador_id_edificio_jugador_seq'::regclass);


--
-- TOC entry 1976 (class 2604 OID 16484)
-- Name: id_mensaje; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY msj ALTER COLUMN id_mensaje SET DEFAULT nextval('msj_id_mensaje_seq'::regclass);


--
-- TOC entry 1975 (class 2604 OID 16457)
-- Name: id_transaccion; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY transaccion ALTER COLUMN id_transaccion SET DEFAULT nextval('transaccion_id_transaccion_seq'::regclass);


--
-- TOC entry 1979 (class 2604 OID 16536)
-- Name: id_unidad; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY unidad ALTER COLUMN id_unidad SET DEFAULT nextval('unidad_id_unidad_seq'::regclass);


--
-- TOC entry 2139 (class 0 OID 16520)
-- Dependencies: 182
-- Data for Name: aldea; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY aldea (id_aldea, id_jugador) FROM stdin;
1	francovp
2	diego
3	diego2
4	diego3
5	diego4
6	diego5
7	francovp2
8	francovp3
9	asdasd
10	francovp4
\.


--
-- TOC entry 2165 (class 0 OID 0)
-- Dependencies: 181
-- Name: aldea_id_aldea_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('aldea_id_aldea_seq', 10, true);


--
-- TOC entry 2137 (class 0 OID 16502)
-- Dependencies: 180
-- Data for Name: ataque; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY ataque (id_ataque, cant_unidades, fecha, id_atacante, id_victima) FROM stdin;
\.


--
-- TOC entry 2166 (class 0 OID 0)
-- Dependencies: 179
-- Name: ataque_id_ataque_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('ataque_id_ataque_seq', 1, true);


--
-- TOC entry 2130 (class 0 OID 16418)
-- Dependencies: 173
-- Data for Name: clan; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY clan (id_clan, cant_miembros, experiencia, nombre) FROM stdin;
\.


--
-- TOC entry 2167 (class 0 OID 0)
-- Dependencies: 172
-- Name: clan_id_clan_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('clan_id_clan_seq', 3, true);


--
-- TOC entry 2142 (class 0 OID 16544)
-- Dependencies: 185
-- Data for Name: detalle_unidades; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY detalle_unidades (id_aldea, id_unidad, cant) FROM stdin;
1	3	2
2	3	2
3	3	2
4	3	2
5	3	2
6	3	2
7	3	2
8	3	2
9	3	2
10	3	2
\.


--
-- TOC entry 2144 (class 0 OID 16561)
-- Dependencies: 187
-- Data for Name: edificio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY edificio (id_edificio, nombre_edificio, costo_edificio, experiencia_base) FROM stdin;
1	Cuarte oscuro	1000	20
3	Campamento	1500	25
4	Caldero de hechizos	1250	30
5	Altar del rey barbaro	100	10
2	Cuartel	500	10
\.


--
-- TOC entry 2168 (class 0 OID 0)
-- Dependencies: 186
-- Name: edificio_id_edificio_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('edificio_id_edificio_seq', 1, false);


--
-- TOC entry 2146 (class 0 OID 16612)
-- Dependencies: 189
-- Data for Name: edificio_jugador; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY edificio_jugador (id_edificio_jugador, nivel_edificio, id_edificio, id_aldea) FROM stdin;
3	1	2	2
4	1	3	2
5	1	2	3
6	1	2	4
7	1	2	5
8	1	2	6
9	1	2	7
10	2	1	6
11	2	4	6
12	2	4	6
13	2	5	6
14	2	5	6
15	1	2	8
16	1	2	9
17	2	1	9
18	2	1	9
19	1	2	10
20	1	2	10
21	1	2	10
22	1	2	10
23	2	3	1
1	3	2	1
\.


--
-- TOC entry 2169 (class 0 OID 0)
-- Dependencies: 188
-- Name: edificio_jugador_id_edificio_jugador_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('edificio_jugador_id_edificio_jugador_seq', 23, true);


--
-- TOC entry 2170 (class 0 OID 0)
-- Dependencies: 190
-- Name: edificio_jugador_id_edificio_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('edificio_jugador_id_edificio_seq', 3, true);


--
-- TOC entry 2131 (class 0 OID 16440)
-- Dependencies: 174
-- Data for Name: jugador; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY jugador (id_jugador, nombre, apellido, email, "contraseña", saldo, exp, sexo, id_clan) FROM stdin;
francovp4	Franco	Valerio	knil@outlook.com	tlozoot	8500	40	Masculino	\N
francovp	Franco	Valerio	franco.gvp@hotmail.com	tlozoot	7000	80	Masculino	\N
diego	diego	mayorga	diego.ignacio.mayorga@gmail.com	manu	10000	0	Masculino	\N
diego2	diego	mayorga	dasjdisa@gmail.com	manu	10000	0	Masculino	\N
diego3	diego	mayorga	diego@gmail.com	123	10000	0	Masculino	\N
diego4	diego	mayorga	dieg2o@gmail.com	123	10000	0	Masculino	\N
francovp2	Franco	Valerio	francovp@outlook.com	tlozoot	10000	0	Masculino	\N
diego5	diego	mayorga	diego5@gmail.com	manu	5300	0	Masculino	\N
francovp3	Franco	Valerio	francosadsada@hotmail.com	tloz	10000	0	Masculino	\N
asdasd	asd	sss	blalba@lala.cl	123456	58000	0	Masculino	\N
\.


--
-- TOC entry 2135 (class 0 OID 16481)
-- Dependencies: 178
-- Data for Name: msj; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY msj (id_mensaje, mensaje, fecha, id_emisor, id_receptor) FROM stdin;
1	hola	2015-06-16	diego4	diego2
\.


--
-- TOC entry 2171 (class 0 OID 0)
-- Dependencies: 177
-- Name: msj_id_mensaje_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('msj_id_mensaje_seq', 1, true);


--
-- TOC entry 2133 (class 0 OID 16454)
-- Dependencies: 176
-- Data for Name: transaccion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY transaccion (id_transaccion, fecha, monto, tipo, id_jugador) FROM stdin;
1	2015-06-16	2000	Compra Edificio(s)	diego5
2	2015-06-16	2500	Compra Edificio(s)	diego5
3	2015-06-16	2500	Compra Edificio(s)	diego5
4	2015-06-16	200	Compra Edificio(s)	diego5
5	2015-06-16	200	Compra Edificio(s)	diego5
6	2015-06-18	2000	Compra Edificio(s)	asdasd
7	2015-06-18	2000	Compra Edificio(s)	asdasd
8	2015-06-18	50000	Carga de Saldo	asdasd
9	2015-06-18	500	Compra Edificio(s)	francovp4
10	2015-06-18	500	Compra Edificio(s)	francovp4
11	2015-06-18	500	Compra Edificio(s)	francovp4
12	2015-06-18	3000	Compra Edificio(s)	francovp
\.


--
-- TOC entry 2172 (class 0 OID 0)
-- Dependencies: 175
-- Name: transaccion_id_transaccion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('transaccion_id_transaccion_seq', 12, true);


--
-- TOC entry 2141 (class 0 OID 16533)
-- Dependencies: 184
-- Data for Name: unidad; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY unidad (id_unidad, nombre, costo) FROM stdin;
1	Barbaro	1000
2	Arquero	500
3	Gigante	100
\.


--
-- TOC entry 2173 (class 0 OID 0)
-- Dependencies: 183
-- Name: unidad_id_unidad_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('unidad_id_unidad_seq', 1, false);


--
-- TOC entry 1999 (class 2606 OID 16525)
-- Name: aldea_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY aldea
    ADD CONSTRAINT aldea_pkey PRIMARY KEY (id_aldea);


--
-- TOC entry 1997 (class 2606 OID 16507)
-- Name: ataque_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ataque
    ADD CONSTRAINT ataque_pkey PRIMARY KEY (id_ataque);


--
-- TOC entry 1987 (class 2606 OID 16712)
-- Name: clan_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY clan
    ADD CONSTRAINT clan_nombre_key UNIQUE (nombre);


--
-- TOC entry 1989 (class 2606 OID 16427)
-- Name: clan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY clan
    ADD CONSTRAINT clan_pkey PRIMARY KEY (id_clan);


--
-- TOC entry 2005 (class 2606 OID 16621)
-- Name: edificio_jugador_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY edificio_jugador
    ADD CONSTRAINT edificio_jugador_pkey PRIMARY KEY (id_edificio_jugador);


--
-- TOC entry 2003 (class 2606 OID 16566)
-- Name: edificio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY edificio
    ADD CONSTRAINT edificio_pkey PRIMARY KEY (id_edificio);


--
-- TOC entry 1991 (class 2606 OID 16446)
-- Name: jugador_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY jugador
    ADD CONSTRAINT jugador_pkey PRIMARY KEY (id_jugador);


--
-- TOC entry 1995 (class 2606 OID 16489)
-- Name: msj_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY msj
    ADD CONSTRAINT msj_pkey PRIMARY KEY (id_mensaje);


--
-- TOC entry 1993 (class 2606 OID 16459)
-- Name: transaccion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY transaccion
    ADD CONSTRAINT transaccion_pkey PRIMARY KEY (id_transaccion);


--
-- TOC entry 2001 (class 2606 OID 16538)
-- Name: unidad_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY unidad
    ADD CONSTRAINT unidad_pkey PRIMARY KEY (id_unidad);


--
-- TOC entry 2017 (class 2620 OID 16698)
-- Name: crear_aldea_inicial; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER crear_aldea_inicial AFTER INSERT ON jugador FOR EACH ROW EXECUTE PROCEDURE crear_aldea_inicial();


--
-- TOC entry 2019 (class 2620 OID 16695)
-- Name: crear_edificio_inicial; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER crear_edificio_inicial AFTER INSERT ON aldea FOR EACH ROW EXECUTE PROCEDURE crear_edificio_inicial();


--
-- TOC entry 2018 (class 2620 OID 16693)
-- Name: crear_unidades_iniciales; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER crear_unidades_iniciales AFTER INSERT ON aldea FOR EACH ROW EXECUTE PROCEDURE crear_unidades_iniciales();


--
-- TOC entry 2012 (class 2606 OID 16526)
-- Name: aldea_id_jugador_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY aldea
    ADD CONSTRAINT aldea_id_jugador_fkey FOREIGN KEY (id_jugador) REFERENCES jugador(id_jugador);


--
-- TOC entry 2010 (class 2606 OID 16508)
-- Name: ataque_id_atacante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ataque
    ADD CONSTRAINT ataque_id_atacante_fkey FOREIGN KEY (id_atacante) REFERENCES jugador(id_jugador);


--
-- TOC entry 2011 (class 2606 OID 16513)
-- Name: ataque_id_victima_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ataque
    ADD CONSTRAINT ataque_id_victima_fkey FOREIGN KEY (id_victima) REFERENCES jugador(id_jugador);


--
-- TOC entry 2013 (class 2606 OID 16549)
-- Name: detalle_unidades_id_aldea_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY detalle_unidades
    ADD CONSTRAINT detalle_unidades_id_aldea_fkey FOREIGN KEY (id_aldea) REFERENCES aldea(id_aldea);


--
-- TOC entry 2014 (class 2606 OID 16554)
-- Name: detalle_unidades_id_unidad_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY detalle_unidades
    ADD CONSTRAINT detalle_unidades_id_unidad_fkey FOREIGN KEY (id_unidad) REFERENCES unidad(id_unidad);


--
-- TOC entry 2016 (class 2606 OID 16627)
-- Name: edificio_jugador_id_aldea_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY edificio_jugador
    ADD CONSTRAINT edificio_jugador_id_aldea_fkey FOREIGN KEY (id_aldea) REFERENCES aldea(id_aldea);


--
-- TOC entry 2015 (class 2606 OID 16622)
-- Name: edificio_jugador_id_edificio_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY edificio_jugador
    ADD CONSTRAINT edificio_jugador_id_edificio_fkey FOREIGN KEY (id_edificio) REFERENCES edificio(id_edificio);


--
-- TOC entry 2006 (class 2606 OID 16447)
-- Name: jugador_id_clan_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY jugador
    ADD CONSTRAINT jugador_id_clan_fkey FOREIGN KEY (id_clan) REFERENCES clan(id_clan);


--
-- TOC entry 2008 (class 2606 OID 16490)
-- Name: msj_id_emisor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY msj
    ADD CONSTRAINT msj_id_emisor_fkey FOREIGN KEY (id_emisor) REFERENCES jugador(id_jugador);


--
-- TOC entry 2009 (class 2606 OID 16495)
-- Name: msj_id_receptor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY msj
    ADD CONSTRAINT msj_id_receptor_fkey FOREIGN KEY (id_receptor) REFERENCES jugador(id_jugador);


--
-- TOC entry 2007 (class 2606 OID 16460)
-- Name: transaccion_nom_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY transaccion
    ADD CONSTRAINT transaccion_nom_usuario_fkey FOREIGN KEY (id_jugador) REFERENCES jugador(id_jugador);


--
-- TOC entry 2155 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2015-06-18 22:56:54

--
-- PostgreSQL database dump complete
--

\connect postgres

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.2
-- Dumped by pg_dump version 9.4.2
-- Started on 2015-06-18 22:56:54

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 1990 (class 1262 OID 12135)
-- Dependencies: 1989
-- Name: postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- TOC entry 173 (class 3079 OID 11855)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 1993 (class 0 OID 0)
-- Dependencies: 173
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 172 (class 3079 OID 16384)
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- TOC entry 1994 (class 0 OID 0)
-- Dependencies: 172
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


--
-- TOC entry 1992 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2015-06-18 22:56:55

--
-- PostgreSQL database dump complete
--

\connect template1

SET default_transaction_read_only = off;

--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.2
-- Dumped by pg_dump version 9.4.2
-- Started on 2015-06-18 22:56:55

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 1989 (class 1262 OID 1)
-- Dependencies: 1988
-- Name: template1; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE template1 IS 'default template for new databases';


--
-- TOC entry 172 (class 3079 OID 11855)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 1992 (class 0 OID 0)
-- Dependencies: 172
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 1991 (class 0 OID 0)
-- Dependencies: 5
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2015-06-18 22:56:56

--
-- PostgreSQL database dump complete
--

-- Completed on 2015-06-18 22:56:56

--
-- PostgreSQL database cluster dump complete
--

