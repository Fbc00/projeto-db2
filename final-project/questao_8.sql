UPDATE contas SET saldo = saldo - 100 WHERE id = 1;
SELECT pg_sleep(2);

-- Tenta bloquear a conta 2 (mas a Sessão 2 já a bloqueou)
UPDATE contas SET saldo = saldo + 100 WHERE id = 2;
-- PostgreSQL irá detectar deadlock aqui após a rotina de detecção de deadlock rodar.
COMMIT;

	BEGIN;
-- Bloqueia a conta 2 para atualização (fazendo o contrário da transaction 1)
UPDATE contas SET saldo = saldo - 50 WHERE id = 2;

SELECT pg_sleep(2);

-- Tenta bloquear a conta 1 (já bloqueada transaction 1)
UPDATE contas SET saldo = saldo + 50 WHERE id = 1;
COMMIT;


-- Há muitas maneiras do postgresql lidar com isso, por default o postgres tem um processo de detecção automática que roda periodicamente
--Exemplo de uma mensagem de erro: ERROR: deadlock detected
--DETAIL: Process 12345 waits for ShareLock on transaction 67890; blocked by process 24680.
--Process 24680 waits for ShareLock on transaction 13579; blocked by process 12345.
--HINT: See server log for query details.
--CONTEXT: while updating tuple (10,10) in relation "contas"
--É possível configurar um timeout para uma transação ser executada nas configurações deadlock_timeout = 1s

