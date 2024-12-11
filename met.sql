DELIMITER $$
DROP PROCEDURE IF EXISTS met;
CREATE PROCEDURE met(
    IN id_cadena INT
)
BEGIN
    DECLARE fi INT DEFAULT 0;
    DECLARE posicion_inicial INT DEFAULT 0;
    DECLARE posicion_final INT DEFAULT 0;
    DECLARE cadena_arn VARCHAR(255);
    DECLARE long_arn INT;
    DECLARE triplet VARCHAR(255);

    SELECT arn, LENGTH(arn) INTO cadena_arn, long_arn FROM adn WHERE idgen = id_cadena;

    SET posicion_inicial = LOCATE('AUG', cadena_arn);
    WHILE posicion_inicial > 0 DO
        SET posicion_final = LOCATE('-', cadena_arn, posicion_inicial + 3);
        IF posicion_final = 0 THEN 
            SET posicion_final = long_arn + 1; 
        END IF;
        SET triplet = SUBSTRING(cadena_arn, posicion_inicial, posicion_final - posicion_inicial);
        
        SELECT 
            CONCAT('ARN: ', cadena_arn) AS Cadena_ARN, 
            CONCAT('Longitud ARN: ', long_arn) AS Longitud_ARN, 
            CONCAT('Posició inicial de AUG: ', posicion_inicial) AS Posicio_Metionina, 
            CONCAT('Seqüència trobada: ', triplet) AS Sequencia_Trobada, 
            CONCAT('Longitud seqüència vàlida: ', LENGTH(triplet)) AS Longitud_Seq;
        
        SET posicion_inicial = LOCATE('AUG', cadena_arn, posicion_inicial + 1);
    END WHILE;
END $$

DELIMITER ;

