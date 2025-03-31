
-- LOST UPDATE

BEGIN;
-- Saldo atual de 1000
SELECT saldo FROM contas WHERE id = 1;


SELECT pg_sleep(3);

-- Atualiza o saldo (baseado no valor lido: 1000 - 200 = 800)
UPDATE contas SET saldo = 800 WHERE id = 1;
COMMIT;


BEGIN;
-- Lê o saldo atual (ainda R$1000) antes da T1 completar
SELECT saldo FROM contas WHERE id = 1;

-- Atualiza o saldo (baseado no valor lido: 1000 + 300 = 1300)
UPDATE contas SET saldo = 1300 WHERE id = 1;
COMMIT;



-- Write Skew
BEGIN;
-- Verifica se a conta 1 pode debitar 200 sem violar o saldo mínimo
SELECT saldo FROM contas WHERE id = 1; -- Vê 600

-- Verifica se a conta 2 existe (não afeta saldo)
 SELECT 1 FROM contas WHERE id = 2 for share;

-- Se saldo atual (600) - valor (200) >= saldo mínimo (500)
UPDATE contas SET saldo = saldo - 200 WHERE id = 1; -- Novo saldo: 400 (viola a regra!)
COMMIT;


BEGIN;
-- Verifica se a conta 2 pode debitar 200 sem violar o saldo mínimo
SELECT saldo FROM contas WHERE id = 2; -- Vê 600

-- Verifica se a conta 1 existe
SELECT 1 FROM contas WHERE id = 1 FOR SHARE;

-- Se saldo atual (600) - valor (200) >= saldo mínimo (500)
UPDATE contas SET saldo = saldo - 200 WHERE id = 2; -- Novo saldo: 400 (viola a regra!)
COMMIT;



-- dirty read
BEGIN;
-- Atualiza o saldo mas NÃO faz commit ainda
UPDATE contas SET saldo = saldo - 200 WHERE id = 1;

-- Mantém a transação aberta (dados modificados mas não commitados)


BEGIN;
-- Lê o saldo não commitado da transação T1 
-- Isso só é possível no nível de isolamento READ UNCOMMITTED
SELECT saldo FROM contas WHERE id = 1; -- Vê o valor -200 não confirmado

-- Toma decisão baseada em dado que pode ser rollback
-- Se T1 fizer ROLLBACK, esta leitura estará incorreta
COMMIT;
