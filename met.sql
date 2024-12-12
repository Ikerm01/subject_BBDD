DELIMITER $$

DROP PROCEDURE IF EXISTS met;
CREATE PROCEDURE met(
    IN id_cadena INT
)
BEGIN
    DECLARE posicion_inicial INT DEFAULT 0;
    DECLARE posicion_final INT DEFAULT 0;
    DECLARE cadena_arn VARCHAR(255);
    DECLARE long_arn INT;
    DECLARE triplet VARCHAR(255);
    DECLARE no_more_rows BOOLEAN DEFAULT FALSE;
    DECLARE cur CURSOR FOR SELECT arn, LENGTH(arn) FROM adn WHERE idgen = id_cadena;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET no_more_rows = TRUE;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO cadena_arn, long_arn;
        IF no_more_rows THEN
            LEAVE read_loop;
        END IF;

        SET posicion_inicial = LOCATE('AUG', cadena_arn);
        IF posicion_inicial = 0 THEN
            SELECT 'La cadena no conté Metionina "AUG"' AS Missatge;
        END IF;

        WHILE posicion_inicial > 0 DO
            SET posicion_final = LOCATE('UAA', cadena_arn, posicion_inicial + 3);
            IF posicion_final = 0 THEN
                SET posicion_final = LOCATE('UAG', cadena_arn, posicion_inicial + 3);
            END IF;
            IF posicion_final = 0 THEN
                SET posicion_final = LOCATE('UGA', cadena_arn, posicion_inicial + 3);
            END IF;
            IF posicion_final = 0 THEN 
                SET posicion_final = long_arn + 1; 
            END IF;
            SET triplet = SUBSTRING(cadena_arn, posicion_inicial, posicion_final - posicion_inicial);

            SELECT 
                CONCAT('ARN: ', cadena_arn) AS Cadena_ARN, 
                CONCAT('Longitud ARN: ', long_arn) AS Longitud_ARN, 
                CONCAT('Posició inicial de AUG: ', posicion_inicial) AS Posicio_Metionina, 
                CONCAT('Seqüència trobada: ', triplet) AS Sequencia_Trobada, 
                CONCAT('Longitud seqüència vàlida: ', LENGTH(triplet)) AS Longitud_Seq,
                IF(posicion_final <= long_arn, 'STOP trobat', 'STOP no trobat') AS Stop_Trobat,
                IF(posicion_final <= long_arn, CONCAT('Posició STOP: ', posicion_final), 'STOP no trobat') AS Posicio_Stop;

            SET posicion_inicial = LOCATE('AUG', cadena_arn, posicion_inicial + 1);
        END WHILE;
    END LOOP;

    CLOSE cur;
END $$

DELIMITER ;