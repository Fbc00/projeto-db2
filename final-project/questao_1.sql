-- Transação 1: Simulando um saque seguro (ACID)
begin;
UPDATE Contas SET saldo = saldo - 200 WHERE id = 1;
INSERT INTO Transacoes (conta_origem, tipo, valor, status) VALUES (1, 'SAQUE', 200, 'CONFIRMADA');
INSERT INTO Logs_Transacoes (transacao_id, evento) VALUES (LASTVAL(), 'Saque realizado com sucesso');
COMMIT;





-- deadlock
BEGIN;
-- Bloqueia a conta 1 para atualização
UPDATE contas SET saldo = saldo - 100 WHERE id = 1;

SELECT pg_sleep(5);

-- Tenta bloquear a conta 2 (mas a transação  2 já a bloqueou)
UPDATE contas SET saldo = saldo + 100 WHERE id = 2;
-- PostgreSQL detectará o deadlock aqui
COMMIT;



BEGIN;
-- Bloqueia a conta 2 para atualização (ordem inversa da Sessão 1)
UPDATE contas SET saldo = saldo - 50 WHERE id = 2;

SELECT pg_sleep(5);

-- Tenta bloquear a conta 1 (já bloqueada pela transação  1)
UPDATE contas SET saldo = saldo + 50 WHERE id = 1;
-- Aqui ocorre o deadlock
COMMIT;




-- verifica se tem deadlock realmente

SELECT pid, 
       usename, 
       pg_blocking_pids(pid) AS blocked_by, 
       query AS blocked_query,
       now() - query_start AS duration
FROM pg_stat_activity
WHERE cardinality(pg_blocking_pids(pid)) > 0;
