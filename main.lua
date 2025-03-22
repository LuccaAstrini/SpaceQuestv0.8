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

function love.load()
  --Carga do cenário
  fundo = LG.newImage('Insumos/Espaco.png')--background
  --Carga do personagem
  personagem.img = LG.newImage('Insumos/Nave.png') --carga da nave
  imgDisparo = LG.newImage('Insumos/projetil.png') --carga de disparo
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
  end