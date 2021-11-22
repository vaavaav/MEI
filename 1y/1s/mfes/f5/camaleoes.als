/* 
Complete o seguinte modelo de uma colónia de camaleões onde o número de 
camaleões é fixo mas onde a cor de cada camaleão pode mudar de acordo com
as seguintes regras: 
- As cores possíveis são Verde, Azul e Amarelo
- Se 2 camaleões de cores diferentes se encontram mudam ambos para a terceira cor
- As cores só se alteram na situação acima 
*/


sig Camaleao {}

pred nop {

}

pred encontro[x,y : Camaleao] {

}

fact Comportamento {
	always (nop or some x,y : Camaleao | encontro[x,y])
}

// Especifique as seguintes propriedades desta colónia

assert Estabilidade {
	// Se os camaleoes ficarem todos da mesma cor, as cores nunca mais mudam

}

check Estabilidade for 5

assert NaoConvergencia {
	// Se inicialmente há um camaleao verde e nenhum azul então não é possível
	// que a colónia fique toda amarela

}

check NaoConvergencia for 5

// Especifique um cenário onde existe um camaleao que não para de mudar de cor
// tomando recorrentemente todas as cores possíveis

run Exemplo {

}

