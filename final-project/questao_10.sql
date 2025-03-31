BEGIN;
-- Simula timestamp mais antigo
SET LOCAL transaction_timestamp = '2023-01-01 10:00:00';

-- Lê transacao
SELECT * FROM trasacoes WHERE id = 1;

SELECT pg_sleep(2);

-- Tenta atualizar
UPDATE trasacoes 
SET conta_origem = 2, conta_destino = 1, valor = 100,
     = transaction_timestamp()
WHERE id = 1 AND data_transacao = '2023-01-01 10:00:00';

-- Verifica se atualizou
IF NOT FOUND THEN
    RAISE EXCEPTION 'Conflito de timestamp: versão mais nova existe';
END IF;

COMMIT;


BEGIN;
-- Simula timestamp mais novo
SET LOCAL transaction_timestamp = '2023-01-01 10:00:01';

-- Atualiza primeiro
UPDATE produtos 
SET conta_origem = 2, conta_destino = 1, valor= 100,
    data_transacao = transaction_timestamp()
WHERE id = 1 AND data_transacao <= '2023-01-01 10:00:01';

COMMIT;
