DROP TABLE IF EXISTS demonstracoes_contabeis;
DROP TABLE IF EXISTS relatorio_cadop;

CREATE TABLE demonstracoes_contabeis(
	DT_REGISTRO DATE,
	REG_ANS VARCHAR(10),
	CD_CONTA_CONTABIL BIGINT,
	DESCRICAO TEXT,
	VL_SALDO_FINAL VARCHAR(20)
);

CREATE TABLE relatorio_cadop(
	REGISTRO_ANS VARCHAR(10),
	CNPJ VARCHAR(20),
	RAZAO_SOCIAL VARCHAR(200),
	NOME_FANTASIA VARCHAR(100),
	MODALIDADE VARCHAR(50),
	LOGRADOURO VARCHAR(50),
	NUMERO VARCHAR(30),
	COMPLEMENTO VARCHAR(50),
	BAIRRO VARCHAR(50),
	CIDADE VARCHAR(30),
	UF CHAR(2),
	CEP CHAR(9),
	DDD VARCHAR(2),
	TELEFONE VARCHAR(30),
	FAX VARCHAR(30),
	ENDERECO_ELETRONICO VARCHAR(80),
	REPRESENTANTE VARCHAR(50),
	CARGO_REPRESENTANTE VARCHAR(50),
	DT_REGISTRO DATE	
);

SET datestyle='ISO, DMY';

COPY demonstracoes_contabeis(DT_REGISTRO, REG_ANS, CD_CONTA_CONTABIL, DESCRICAO, VL_SALDO_FINAL) FROM '/tmp/1T2020.csv' DELIMITER ';' CSV HEADER ENCODING 'iso-8859-1';
COPY demonstracoes_contabeis(DT_REGISTRO, REG_ANS, CD_CONTA_CONTABIL, DESCRICAO, VL_SALDO_FINAL) FROM '/tmp/2T2020.csv' DELIMITER ';' CSV HEADER ENCODING 'iso-8859-1';
COPY demonstracoes_contabeis(DT_REGISTRO, REG_ANS, CD_CONTA_CONTABIL, DESCRICAO, VL_SALDO_FINAL) FROM '/tmp/3T2020.csv' DELIMITER ';' CSV HEADER ENCODING 'iso-8859-1';
COPY demonstracoes_contabeis(DT_REGISTRO, REG_ANS, CD_CONTA_CONTABIL, DESCRICAO, VL_SALDO_FINAL) FROM '/tmp/4T2020.csv' DELIMITER ';' CSV HEADER ENCODING 'iso-8859-1';
COPY demonstracoes_contabeis(DT_REGISTRO, REG_ANS, CD_CONTA_CONTABIL, DESCRICAO, VL_SALDO_FINAL) FROM '/tmp/1T2021.csv' DELIMITER ';' CSV HEADER ENCODING 'iso-8859-1';
COPY demonstracoes_contabeis(DT_REGISTRO, REG_ANS, CD_CONTA_CONTABIL, DESCRICAO, VL_SALDO_FINAL) FROM '/tmp/2T2021.csv' DELIMITER ';' CSV HEADER ENCODING 'iso-8859-1';

COPY relatorio_cadop
(REGISTRO_ANS, CNPJ, RAZAO_SOCIAL, NOME_FANTASIA, MODALIDADE, LOGRADOURO, NUMERO, COMPLEMENTO, BAIRRO, CIDADE, UF, CEP, DDD, TELEFONE, FAX, ENDERECO_ELETRONICO, REPRESENTANTE, CARGO_REPRESENTANTE, DT_REGISTRO) 
FROM '/tmp/Relatorio_cadop.csv' CSV HEADER DELIMITER ';' ENCODING 'iso-8859-1';

-- Quais as 10 operadoras que mais tiveram despesas com "EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR" no último trimestre?

SELECT
	rel.registro_ans,
	rel.cnpj,
	rel.razao_social,
	TO_CHAR(dc.dt_registro, 'MM/YYYY') mes_referencia, 
	SUM(CAST(REPLACE(dc.vl_saldo_final,',','.') AS NUMERIC)) saldo_final
FROM
	demonstracoes_contabeis dc
	INNER JOIN relatorio_cadop rel ON dc.reg_ans = rel.registro_ans
WHERE
	descricao LIKE '%Evento%%Sinistro%Hospitalar%'
	AND dc.dt_registro >= '2021-04-01'
GROUP BY 
	rel.registro_ans,
	rel.cnpj,
	rel.razao_social,
	TO_CHAR(dc.dt_registro, 'MM/YYYY'),
	dc.dt_registro
ORDER BY
	saldo_final
FETCH FIRST 10 ROWS ONLY;

-- Quais as 10 operadoras que mais tiveram despesas com "EVENTOS/ SINISTROS CONHECIDOS OU AVISADOS  DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR" no último ano?

SELECT
	rel.registro_ans,
	rel.cnpj,
	rel.razao_social,
	TO_CHAR(dc.dt_registro, 'MM/YYYY') mes_referencia, 
	SUM(CAST(REPLACE(dc.vl_saldo_final,',','.') AS NUMERIC)) saldo_final
FROM
	demonstracoes_contabeis dc
	INNER JOIN relatorio_cadop rel ON dc.reg_ans = rel.registro_ans
WHERE
	descricao LIKE '%Evento%%Sinistro%Hospitalar%'
	AND dc.dt_registro >= '2021-01-01'
GROUP BY 
	rel.registro_ans,
	rel.cnpj,
	rel.razao_social,
	TO_CHAR(dc.dt_registro, 'MM/YYYY'),
	dc.dt_registro
ORDER BY
	saldo_final
FETCH FIRST 10 ROWS ONLY;