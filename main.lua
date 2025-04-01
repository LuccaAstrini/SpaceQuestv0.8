-- Apelidos para chamadas 
local LG = love.graphics
local LK = love.keyboard

--Variáveis globais
--personagem = nil -- nil -> vazio/nulo
personagem = {posX = 0, posY = 0, veloc = 150, img = nil}
modoTurbo = false

--Estrutura para os disparos
podeAtirar = true
tempoTiroMax = 0.2 --temporização, só pode atirar após 2 segundos que é o tempo máximo
tiroAtual = tempoTiroMax 
imgDisparo = nil
disparo = {} -- tabela de disparos realizados 

--Estrutura para inimigos
tempoInimMax = 0.4
InimAtual = tempoInimMax
margemInimigo = 0 -- estar dentro da margem sem sair fora da tela
imgInimigo = nil
inimigos = {} -- tabela do inimigo na tela
velocInimigo = 200

--Controle de pontuação e Game Over
Vivo = true
Pontos = 0

function love.load()
  --Carga do cenário
  fundo = LG.newImage('Insumos/Espaco.png') --background
  --Cálculo para posicionar no centro da tela
  personagem.img = LG.newImage('Insumos/Nave.png') --carga 
  --Carga do tiro
  imgDisparo = LG.newImage('Insumos/projetil.png')
  --Calculo para posicionar no centro da tela 
  meioh = (LG.getWidth() - personagem.img:getWidth()) / 2
  meiov = (LG.getHeight() - personagem.img:getHeight()) / 2
  --Carga do Inimigo
  imgInimigo = LG.newImage('Insumos/Nave-inimiga.png')
  margemInimigo = imgInimigo:getWidth() /2
  
  
  --Inicializa a posição do personagem
  personagem.posX = meioh
  personagem.posY = meiov
  
  --Realizando a carga dos efeitos sonoros (Spound FX)
  Tiro = love.audio.newSource('Insumos/tiro.wav', 'static')
  Turbo = love.audio.newSource('Insumos/modoturbo.wav', 'static')
  TiroTurbo = love.audio.newSource('Insumos/tirolaser.wav', 'static')
end
function love.draw()
  LG.draw(fundo, 0, 0) -- carga do cenário
  
  --Renderiza o personagem
  if Vivo then 
    LG.draw(personagem.img, personagem.posX, personagem.posY)
  else
    LG.print('Pressione R para reiniciar ou ESC para Sair', LG.getWidth() / 2 - 50, LG.getHeight() / 2 -10)
  end
  
  --Renderização dos disparos
  for i, proj in pairs(disparo) do
    LG.draw(imgDisparo, proj.x, proj.y)
  end
  --Renderização dos inimigos
  for i, atual in ipairs(inimigos) do
    LG.draw(imgInimigo, atual.x, atual.y)
  end
  
  -- Montar um placar simples
  LG.setColor(1,1,1,1)
  LG.print('PONTOS' .. tostring(Pontos), 400,10)
    
end
function love.update(dt)
  --Controle para sair do jogo
  if LK.isDown('escape') then
    love.event.quit()
  end
  
  --Reiniciar o jogo
  if LK.isDown('r') and not Vivo then
    Reiniciar()
  end
  
  --Controle do personagem
  if LK.isDown('left', 'a') then --movimentação para a esquerda
    if personagem.posX > 0 then
    personagem.posX = personagem.posX - personagem.veloc * dt
    end
  elseif LK.isDown('right', 'd') then --movimentação para a direita
    if personagem.posX < (LG.getWidth() - personagem.img:getWidth()) then
    personagem.posX = personagem.posX + personagem.veloc * dt
    end
  end
  
  if modoTurbo then 
    if LK.isDown('up', 'w') then -- para cima
      if personagem.posY > (LG.getHeight() / 2) then -- até o meio da tela
        personagem.posY = personagem.posY - 250 * dt
    end
  elseif LK.isDown('down', 's') then -- para baixo
    if personagem.posY < LG.getHeight() - personagem.img:getHeight() then
      personagem.posY = personagem.posY + 250 * dt
    end
  end
  end

  
  --Controle de Temporização de Disparos
  tiroAtual = tiroAtual - (1 * dt) 
  if tiroAtual < 0 then
    podeAtirar = true
  end
  --Controle de disparo
  if LK.isDown('space', 'rctrl', 'lctrl') and podeAtirar and Vivo then
    --Criar uma instancia no projetil
    if not modoTurbo then
      nvProjetil = {x = personagem.posX + personagem.img:getWidth() / 2, y = personagem.posY } -- x -> meio da nave
      table.insert(disparo, nvProjetil)
      -- Disparar o efeito sonoro do tiro normal
      Tiro:play()
    else
      desloca = 30 
      n1Projetil = {x = personagem.posX + personagem.img:getWidth() / 2 - desloca, y = personagem.posY}
      n2Projetil = {x = personagem.posX + personagem.img:getWidth() / 2 + desloca, y = personagem.posY}
      
      table.insert(disparo, n1Projetil)
      table.insert(disparo, n2Projetil)
      --Disparar o efeito sonoro tiro turbo
      TiroTurbo:play()
    end

    podeAtirar = false
    tiroAtual = tempoTiroMax
  end
  --Animar o projetil do disparo
  for i, proj in ipairs(disparo) do
    proj.y = proj.y - (250 * dt)
    --Se sair da tela é preciso eliminar da tabela
    if(proj.y < 0) then
      table.remove(disparo, i) -- i -> indice da tabela que estou manipulando 
    end
  end
  --Temporizar os inimigos
  InimAtual = InimAtual - (1 * dt)
  if (InimAtual < 0 ) then
    InimAtual = tempoInimMax
    --Criar uma nova instancia do inimigo (automatico)
    math.randomseed(os.time())  --do sistema operacional pega a hora, para o inimigo não aparecer sempre na mesma posição
    posDinamica = math.random(10 + margemInimigo, LG.getWidth() - (10 + margemInimigo))
    nvInimigo = {x = posDinamica, y = -10}
    table.insert(inimigos, nvInimigo)
  end
  --Animação dos inimigos
  for i, atual in ipairs(inimigos) do 
    atual.y = atual.y + (velocInimigo * dt)
  --remover o inimigo se passar o final da tela
    if atual.y > LG.getHeight() then
      table.remove(inimigos, i)
    end
  end
  -- Detecção de colisões
  for i, vilao in ipairs(inimigos) do
    for j, proj in ipairs(disparo) do
      if verColisao(vilao.x, vilao.y, imgInimigo:getWidth(), imgInimigo:getHeight(), proj.x, proj.y, imgDisparo:getWidth(), imgDisparo:getHeight()) then
        --Existiu a colisão
        table.remove(disparo, j)
        table.remove(inimigos, 1)
        Pontos = Pontos + 10 -- cada vez que mata o inimigo ganha 10 pontos
        --Verificação para entrar no modo turbo
       -- modoTurbo = (Pontos > 150) Forma de tirar o if, diminui recurso da maquina
        if Pontos > 150 and not modoTurbo then
          modoTurbo = true
          Turbo:play()
          velocInimigo = 300
        end
      end
    end
    --Verificar se os inimigos colidiu com o personagem
    if verColisao(vilao.x, vilao.y, imgInimigo:getWidth(), imgInimigo:getHeight(), personagem.posX, personagem.posY, personagem.img:getWidth(), personagem.img:getHeight()) then
      -- Colidiu com o personagem
      table.remove(inimigos, i)
      Vivo = false
    end 
  end
  
end

-- Colisão
function verColisao(x1, y1,  w1, h1, x2, y2, w2, h2)
  return (x2+w2 >= x1 and x2 <= x1+w1 and y2+h2 >= y1 and y2 <= y1+h1)
end

function Reiniciar()
  -- Limpar as tabelas
  disparos = {}
  inimigos = {}
  -- Reiniciar os temporizadores
  TiroAtual = tempoTiroMax
  InimAtual = tempoInimMax
  --Posiciona o jogador na posiçao iniciail
  personagem.posX = meioh
  personagem.posY = meiov
  --Reiniciar o placar
  velocInimigo = 200
  Pontos = 0
  Vivo = true
  modoTurbo = false
end