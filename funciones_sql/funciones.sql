-- PARA PROBAR LAS FUNCIONES
-- SELECT *Funcion(parametros);*
-- ejemplo:
-- SELECT verificar_usuario('juanchitox@mail.com','soyro');

---------------------FUNCIONES PARA EL INGRESO -----------------
--Verifica que corresponda el password y el mail
CREATE OR REPLACE FUNCTION verificar_usuario(id text, pass text) RETURNS BOOLEAN AS $$
DECLARE
BEGIN
		IF (select contraseña FROM jugador WHERE id_jugador=$1)=$2 THEN
			RETURN TRUE;
		ELSE
			RETURN FALSE;
		END IF;
END;
$$ LANGUAGE plpgsql;

--Verifica que el mail ingresado no exista, para poder hacer el cambio de email o crear el usuario nuevo
CREATE OR REPLACE FUNCTION verificar_email(mail text) RETURNS BOOLEAN AS $$
	BEGIN
		IF(select email FROM jugador WHERE email=$1)=$1 THEN
			RETURN FALSE;
		ELSE
			RETURN TRUE;
		END IF;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION verificar_pass(id text, pass text) RETURNS BOOLEAN AS $$
	BEGIN
		IF(select contraseña FROM jugador WHERE id_jugador=$1)=$2 THEN
			RETURN TRUE;
		ELSE
			RETURN FALSE;
		END IF;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION verificar_clan(name text) RETURNS BOOLEAN AS $$
	BEGIN
		IF(select nombre FROM clan WHERE nombre=$1)=$1 THEN
			RETURN TRUE;
		ELSE
			RETURN FALSE;
		END IF;
	END;
$$ LANGUAGE plpgsql;

------------------------------FUNCIONES PARA JUGADOR-----------------------

CREATE OR REPLACE FUNCTION crear_jugador(id text, nombre text, apellido text, sexo text, mail text, pass text) RETURNS BOOLEAN AS $$
BEGIN
	INSERT INTO jugador(id_jugador,nombre,apellido,sexo,email,contraseña) VALUES ($1,$2,$3,$4,$5,$6);
	RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION crear_clan(nombre text, lider text, cantidad integer, experiencia integer) RETURNS BOOLEAN AS $$ 
BEGIN 
	INSERT INTO clan(nombre,id_lider,experiencia,cant_miembros)values($1,$2,$3,$4);
	RETURN TRUE;
END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION crear_aldea (id text) RETURNS boolean AS $$
BEGIN 
	INSERT INTO aldea(id_jugador) VALUES ($1);
	RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION crear_edificio (aldea integer, edificio integer, nivel integer) RETURNS boolean AS $$
BEGIN 
	INSERT INTO edificio_jugador (id_aldea,id_edificio,nivel_edificio) VALUES ($1,$2,$3);
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION crear_unidad_jugador (id_aldea integer, id_unidad integer, cantidad integer) RETURNS boolean AS $$
DECLARE
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
$$ LANGUAGE plpgsql;

--------------------------------------------- TRIGGERS------------------------------------------------

CREATE TRIGGER crear_aldea_inicial AFTER INSERT ON jugador 
FOR EACH ROW EXECUTE PROCEDURE crear_aldea_inicial();

CREATE OR REPLACE FUNCTION crear_aldea_inicial () RETURNS TRIGGER AS $$
BEGIN 
	INSERT INTO aldea (id_jugador) VALUES (NEW.id_jugador);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER crear_edificio_inicial AFTER INSERT ON aldea 
FOR EACH ROW EXECUTE PROCEDURE crear_edificio_inicial();

CREATE OR REPLACE FUNCTION crear_edificio_inicial () RETURNS TRIGGER AS $$
BEGIN 
	INSERT INTO edificio_jugador (id_aldea,id_edificio,nivel_edificio) VALUES (NEW.id_aldea,2,1);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER crear_unidades_iniciales AFTER INSERT ON aldea 
FOR EACH ROW EXECUTE PROCEDURE crear_unidades_iniciales();

CREATE OR REPLACE FUNCTION crear_unidades_iniciales () RETURNS trigger AS $$
BEGIN
        INSERT INTO detalle_unidades (id_aldea,id_unidad,cant) VALUES (NEW.id_aldea,3,2);
        RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-----------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION registrar_transaccion (fech date, costo integer, tipo text, id integer) RETURNS boolean AS $$
BEGIN 
	INSERT INTO transaccion (fecha,monto,tipo,id_jugador) VALUES ($1,$2,$3,$4);
	RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION registrar_mensaje (msj text, fech date, emisor text, receptor text) RETURNS boolean AS $$
BEGIN 
	INSERT INTO msj (mensaje,fecha,id_emisor,id_receptor) VALUES ($1,$2,$3,$4);
	RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

------------------ FUNCIONES PARA OBTENER DATOS ------------------------------

CREATE OR REPLACE FUNCTION obtener_id (id text) RETURNS TEXT AS $$
BEGIN
	RETURN (SELECT id_jugador FROM jugador WHERE id=$1);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION obtener_id_clan (name text) RETURNS integer AS $$
BEGIN
	RETURN (SELECT id_clan FROM clan WHERE nombre=$1);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION obtener_nombre_clan (id text) RETURNS text AS $$
BEGIN
	RETURN (SELECT nombre FROM clan WHERE id_clan=$1);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION obtener_exp_clan (name text) RETURNS integer AS $$
BEGIN
	RETURN (SELECT experiencia FROM clan WHERE nombre=$1);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION obtener_cant_miembros_clan (id integer) RETURNS integer AS $$
BEGIN
	RETURN (SELECT cant_miembros FROM clan WHERE id_clan=$1);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION obtener_id_aldea (id text) RETURNS integer AS $$
BEGIN
	RETURN (SELECT id_aldea FROM aldea WHERE id_jugador=$1);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION obtener_saldo (id text) RETURNS integer AS $$
BEGIN
	RETURN (SELECT saldo FROM jugador WHERE id_jugador=$1);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION obtener_costo_edificio (id integer) RETURNS INTEGER AS $$
BEGIN
	RETURN (SELECT costo_edificio FROM edificio WHERE id_edificio=$1);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION obtener_nivel_edificio (id integer) RETURNS INTEGER AS $$
BEGIN
	RETURN (SELECT nivel_edificio FROM edificio_jugador WHERE id_edificio_jugador = $1);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION obtener_costo_unidad (id integer) RETURNS INTEGER AS $$
BEGIN
	RETURN (SELECT costo FROM unidad WHERE id_unidad=$1);
END;
$$ LANGUAGE plpgsql;

------------------------Funciones para modificar datos---------------------------------

CREATE OR REPLACE FUNCTION modificar_jugador (nom text, apell text, genero text, mail text, pass text, id text) RETURNS BOOLEAN AS $$
BEGIN
	UPDATE jugador SET nombre = $1 WHERE id_jugador = $6;
	UPDATE jugador SET apellido = $2 WHERE id_jugador = $6;
	UPDATE jugador SET email = $3 WHERE id_jugador = $6;
	UPDATE jugador SET sexo = $4 WHERE id_jugador = $6;
	UPDATE jugador SET contraseña = $5 WHERE id_jugador = $6;
	RETURN TRUE;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION modificar_pass (dato text, id text) RETURNS BOOLEAN AS $$
	BEGIN
		IF ($1 = '') THEN --Valida por si el campo es recibido vacio
			RETURN FALSE;
		ELSE
			UPDATE jugador SET contraseña = $1 WHERE id_jugador = $2;
			RETURN TRUE;
		END IF;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION modificar_saldo (dato integer, id text) RETURNS BOOLEAN AS $$
	BEGIN
		UPDATE jugador SET saldo = $1 WHERE id_jugador = $2;
		RETURN TRUE;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION modificar_id_clan (clan integer, jugador text) RETURNS BOOLEAN AS $$
	BEGIN
		UPDATE jugador SET id_clan = $1 WHERE id_jugador = $2;
		RETURN TRUE;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION modificar_exp_clan (dato integer, clan text) RETURNS BOOLEAN AS $$
	BEGIN
		UPDATE clan SET experiencia = $1 WHERE nombre = $2;
		RETURN TRUE;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION modificar_exp_jugador (dato integer, id text) RETURNS BOOLEAN AS $$
	BEGIN
		UPDATE jugador SET exp = $1 WHERE id_jugador = $2;
		RETURN TRUE;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION modificar_nivel_edificio (dato integer, id integer) RETURNS BOOLEAN AS $$
	BEGIN
		UPDATE edificio_jugador SET nivel_edificio = $1 WHERE id_edificio_jugador = $2;
		RETURN TRUE;
	END;
$$ LANGUAGE plpgsql;

-------------------------------- Eliminaciones de Clan --------------------------------------------

CREATE OR REPLACE FUNCTION eliminar_jugador_de_clan (id text) RETURNS BOOLEAN AS $$
	BEGIN
		UPDATE jugador SET id_clan = null WHERE id_jugador = $1;
		RETURN TRUE;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION eliminar_clan (id integer) RETURNS BOOLEAN AS $$
	BEGIN
		DELETE FROM clan WHERE id_clan = $1;
		RETURN TRUE;
	END;
$$ LANGUAGE plpgsql;