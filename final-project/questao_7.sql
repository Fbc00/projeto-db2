BEGIN;
-- Fase de Expansão: Aqui é buscado obter todos os bloqueio necessário para executar a transação

-- Bloqueio de leitura na conta origem
SELECT * FROM contas WHERE id = 1 FOR SHARE;

-- Bloqueio de leitura na conta destino
SELECT * FROM contas WHERE id = 2 FOR SHARE;

SELECT pg_sleep(1); 

-- Promove para bloqueio de escrita na conta origem
-- (Permanece na fase de expansão pois está convertendo, não liberando)
SELECT * FROM contas WHERE id = 1 FOR UPDATE;

-- Promove para bloqueio de escrita na conta destino
SELECT * FROM contas WHERE id = 2 FOR UPDATE;

UPDATE contas SET saldo = saldo - 100 WHERE id = 1;
UPDATE contas SET saldo = saldo + 100 WHERE id = 2;

COMMIT; -- Libera todos os bloqueios (fase de contração)

