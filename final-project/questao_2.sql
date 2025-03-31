BEGIN;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;  




SELECT saldo FROM contas WHERE id = 1;


INSERT INTO logs_testes (questao_id, evento, equipe_id, extra) select 2, 'SERIAL FIRST TRANSACTION', 1, c.saldo from contas c  where id = 1;
UPDATE contas SET saldo = saldo - 600 WHERE id = 1;


SELECT pg_sleep(10); -- simula transação demorada




BEGIN;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;




UPDATE contas SET saldo = saldo - 500 WHERE id = 1;
INSERT INTO logs_testes (questao_id, evento, equipe_id, extra) select 2, 'SERIAL SECOND TRANSACTION', 1, c.saldo from contas c  where id = 1;




COMMIT;  
INSERT INTO logs_testes (questao_id, evento, equipe_id, extra) select 2, 'SERIAL FINAL ', 1, c.saldo from contas c  where id = 1;
—---- Equivalente —--
-- transação 1
BEGIN;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;


SELECT saldo FROM contas WHERE id = 1;  -- Saldo: 1000
UPDATE contas SET saldo = saldo - 600 WHERE id = 1;
INSERT INTO logs_testes (questao_id, evento, equipe_id, extra) select 2, 'Equivalente a Serial FIRST TRANSACTION', 1, c.saldo from contas c  where id = 1;
SELECT pg_sleep(5);
COMMIT;  


 -- transação 2 (executar em paralelo)
BEGIN;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;


SELECT saldo FROM contas WHERE id = 1;  -- Também vê 1000 (snapshot)
INSERT INTO logs_testes (questao_id, evento, equipe_id, extra) select 2, 'Equivalente a Serial SECOND TRANSACTION', 1, c.saldo from contas c  where id = 1;
UPDATE contas SET saldo = saldo - 500 WHERE id = 1;
COMMIT;  -- Falhará com erro "could not serialize access"



