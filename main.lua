--apelidos
local LG = love.graphics
local LK = love.keyboard
--variáveis globais
personagem = {posX=0, posY=0, veloc=150, img=nil}

--Estrutura para os disparos
podeAtirar = true
tempoTiroMax = 0.2
TiroAtual = tempoTiroMax
imgDisparo = nil
disparos = {} -- tablea de disparos realizados

-- Estrutura para inimigos
tempoInMax = 0.4
inimAtual = tempoInMax
margemInimigo = 0
imgInimigo = nil
inimigo = {} -- Tabela de inimigos na tela

function love.load()
  --Carga do cenário
  fundo = LG.newImage('Insumos/Espaco.png')--background
  --Carga do personagem
  personagem.img = LG.newImage('Insumos/Nave.png') --carga da nave
  imgDisparo = LG.newImage('Insumos/projetil.png') --carga de disparo
  --Carga do inimigo
  imgInimigo = LG.newImage("Insumos/Nave-inimiga.png")
  margemInimigo = imgInimigo:getWidth()/2
  --Calculo para posicionar no centro da tela
  meioh = (LG.getWidth() - personagem.img:getWidth())/2
  meiov = (LG.getHeight() - personagem.img:getHeight())/2
  --Inicializar a posição do personagem
  personagem.posX = meioh
  personagem.posY = meiov
end

function love.draw()
  LG.draw(fundo,0,0) -- carga cenário
  LG.draw(personagem.img, personagem.posX, personagem.posY)
  --Renderização dos disparos
  for i, proj in ipairs(disparos) do
    LG.draw(imgDisparo, proj.x, proj.y)
  end
  --Renderização dos inimigos
  for i, atual in ipairs(inimigo) do
    LG.draw(imgInimigo, atual.x, atual.y)
  end
  
end

function love.update(dt)
  --Controle para sair do jogo
  if LK.isDown('escape') then
    love.event.push('quit')
  end
  if LK.isDown('left','a') then --movimentação para esquerda
    if personagem.posX > 0 then
      personagem.posX = personagem.posX - personagem.veloc *dt
    end
  elseif LK.isDown('right', 'd') then
    if personagem.posX < (LG.getWidth() - personagem.img:getWidth()) then
      personagem.posX = personagem.posX + personagem.veloc * dt
      end
    end
    --Controle de temporização de Disparos
    TiroAtual = TiroAtual - (1*dt)
    if TiroAtual < 0 then
      podeAtirar = true
    end
    --Controle de Disparo
    if LK.isDown('space','rctrl', 'lctrl') and podeAtirar then
      --Criar uma instancia do projetil
      nvProjetil = {x = personagem.posX + personagem.img:getWidth()/2, y = personagem.posY}
      table.insert(disparos, nvProjetil)
      podeAtirar = false
      TiroAtual = tempoTiroMax
      end
      --Animar o projetil do disparo
      for i, proj in ipairs(disparos) do
        proj.y = proj.y - (250 * dt)
        --Se ele sair da tela é preciso eliminar da tabela
        if(proj.y < 0) then
          table.remove(disparos, i)
        end
      end
      --Temporizar os inimigos
      inimAtual = inimAtual - (1 * dt)
      if(inimAtual < 0) then
        inimAtual = tempoInMax
        --Criar uma Instancia
        math.randomseed(os.time())
        posDinamico = math.random(10 + margemInimigo, LG.getWidth() - (10+margemInimigo))
        nvInimigo = {x = posDinamico, y = -10}
        table.insert(inimigo, nvInimigo)
      end
      --Animação do inimigo
      for i, atual in ipairs(inimigo) do
        atual.y = atual.y + (200 * dt)
        --Remover o inimigo se pasar o final da tela
        if atual.y > LG.getWidth()then
          table.remove(inimigo, i)
        end
      end
  end