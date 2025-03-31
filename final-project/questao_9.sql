BEGIN;
-- Lê a versão atual do produto (cria snapshot)
SELECT * FROM contas WHERE id = 1;
-- Resultado: 
SELECT pg_sleep(3);
-- Atualiza o estoque
UPDATE produtos SET estoque = saldo - 1 WHERE id = 1;
COMMIT; -- ao executar o commit  uma nova versão é criada
BEGIN;
-- Esta transação vê o SNAPSHOT no momento de seu início
SELECT saldo FROM contas WHERE id = 1;
-- Resultado: Saldo = 999;
-- Continua vendo os dados antigos até COMMIT da Transação 1
COMMIT;
-- Query para verificar as estatísticas do MVCC
SELECT n_dead_tup, last_vacuum FROM pg_stat_user_tables
WHERE relname = 'contas';



--Versões Múltiplas:
--	Antes do UPDATE: versão X (saldo=1000)
--	Após UPDATE: versão Y (saldo=999)
--	Ambas versões existem temporariamente
--Isolamento:
--	Transação 2 vê apenas versões commitadas no momento de seu início
--	Transação 1 trabalha com versão não commitada visível apenas para ela
--Visibilidade:
--	Cada transação tem seu próprio "snapshot" dos dados
--	Novas versões só ficam visíveis após COMMIT
