BEGIN;
-- Aqui adquiro o read block
SELECT * FROM contas WHERE id = 1 FOR SHARE;

SELECT pg_sleep(3);

SELECT * FROM contas WHERE id = 1 FOR UPDATE NOWAIT; - - write block
-- Atualizo o saldo agora que conseguir o write block
UPDATE contas SET saldo = saldo - 150 WHERE id = 1;
COMMIT;

