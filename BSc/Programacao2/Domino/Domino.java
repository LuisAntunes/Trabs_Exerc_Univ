import java.util.Scanner;
import javax.swing.JOptionPane;

public class Domino {
	
	public void jogoD(){
		Scanner input = new Scanner(System.in);
		String j;
		
		int n; // duplo-n
		int ind; //variavel que ira conter o input da peca a remover (indice da mao do jogador) 
		int podeJog;
		int in;
		int fim;
		
		JOptionPane.showMessageDialog(null, "Bem vindo ao jogo de Domino!");
		
		String nS = JOptionPane.showInputDialog(null,"Qual o jogo de duplo-n que pretende iniciar? (Insira n)");
		n = Integer.parseInt(nS);

		j = JOptionPane.showInputDialog(null, "Qual e o seu nome?");
		JOptionPane.showMessageDialog(null, "\nBoa sorte "+ j + "!\n");
	
		JogoDeDomino y = new JogoDeDomino(j, n);
		y.inc = 0;
		
		System.out.println(j + ": " + y.mostraPedras()); 
		System.out.println("Mesa: " + y.mostraMesa());
		System.out.println("\nComputador:"  + y.maoC.size() + " pecas");
		
		if(y.player == 0){
			System.out.println("\nVez do computador.");
		}
		
		y.itJ = y.maoJ.listIterator(); 
		
		// Loop principal do jogo
		while (!y.banca.isEmpty()){
			
			/* De seguida e verificado se a mao do jogador ou do computador ficou vazia. Caso isto se 
			 * verifique e mostrado quem ganhou o jogo e e terminado o loop principal.*/
			if (y.maoJ.isEmpty()){
				JOptionPane.showMessageDialog(null, "Parabens " + j + ", ganhou o jogo!", "Fim de Jogo", JOptionPane.INFORMATION_MESSAGE);
				break;
			}
			else if(y.maoC.isEmpty()){
				JOptionPane.showMessageDialog(null, "Parece que o computador ganhou. Fica para a proxima.", "Fim de Jogo", JOptionPane.INFORMATION_MESSAGE);
				break;
			}
			in = y.mesa.get(0).getLadoEsq(); // inicio da mesa
			fim = y.mesa.get(y.mesa.size()-1).getLadoDir(); // fim da mesa
			
			/* De seguida ira ser verificado se o jogador pode jogar alguma peca, caso nao possa jogar
			 * nenhuma ser-lhe-a retirada uma da banca e se nao puder joar essa passa logo para o 
			 * computador*/
			podeJog = 0;
			for(int i = 0;i < y.maoJ.size();i++){
				if (y.maoJ.get(i).getLadoEsq()==in || y.maoJ.get(i).getLadoDir() == in || y.maoJ.get(i).getLadoEsq()==fim || y.maoJ.get(i).getLadoDir() == fim){
					podeJog++;
				}
			}
			if (y.player == 1 && podeJog == 0){
				podeJog = 0;
				System.out.println("\nNao pode jogar nenhuma peca. Ira ser retirada uma da banca.");
				y.randomInt = y.aleatorio.nextInt(y.banca.size());
				y.maoJ.add(y.banca.get(y.randomInt));
				
				System.out.println("\n"+y.banca.get(y.randomInt).pedraToString());
				System.out.println("\n" + j + ": " + y.mostraPedras());
				System.out.println("Mesa: " + y.mostraMesa());
				
				y.banca.remove(y.randomInt);
				in = y.mesa.get(0).getLadoEsq();
				fim = y.mesa.get(y.mesa.size()-1).getLadoDir();
				for(int i = 0;i < y.maoJ.size();i++){
					if (y.maoJ.get(i).getLadoEsq()==in || y.maoJ.get(i).getLadoDir() == in || y.maoJ.get(i).getLadoEsq()==fim || y.maoJ.get(i).getLadoDir() == fim){
						podeJog++;
					}
				}
				if(podeJog == 0){
					System.out.println("\nNao pode jogar a peca removida da banca.");
					System.out.println("\nVez do computador.");
					y.player = 0;
				}
			}
			// jogada do jogador
			if (y.player == 1){
				System.out.println("\nQual a peca que deseja jogar?\nIndique o numero da peca de 1 a "+y.maoJ.size()+ ".");
				ind = input.nextInt();
				ind -= 1;
				/* enquanto nao escolher dentro do intervalo pedido ira continuar a mostrar uma 
				 * mensagem e a pedir o numero correspondente a peca*/
				while(ind > (y.maoJ.size()-1)){
					JOptionPane.showMessageDialog(null, "Escolha uma das pecas no intervalo pedido", "Erro", JOptionPane.ERROR_MESSAGE);
					System.out.println("\nQual a peca que deseja jogar?\nIndique o numero da peca de 1 a "+y.maoJ.size()+ ".");
					ind = input.nextInt();
				}
					
				/* no proximo loop foi utilizado o iterador para ir buscar a peca ao indice que foi
				 * pedido ao utilizador e usa-la como argumento na funcao jogajogador para verificar
				 * se a pode jogar*/
				y.itJ = y.maoJ.listIterator();
				while(y.itJ.hasNext()){
					if (y.maoJ.get(ind) == y.itJ.next()){
						y.jogaJogador(y.maoJ.get(ind));
						break;
					}
				}
					
				y.player = 0;
				System.out.println("\n" + j + ": " + y.mostraPedras());
				System.out.println("Mesa: " + y.mostraMesa());
				System.out.println("\nComputador:"  + y.maoC.size() + " pecas");
				System.out.println("Banca:"  + y.banca.size() + " pecas");
			}
			//jogada do computador
			else{
				y.inc = 0;
				
				y.jogaComputador();
				System.out.println("\nE a sua vez " + j + ".");
				System.out.println("\n" + j + ": " + y.mostraPedras());
				System.out.println("Mesa: " + y.mostraMesa());
				System.out.println("\nComputador:"  + y.maoC.size() + " pecas");
				System.out.println("Banca:"  + y.banca.size() + " pecas");
				y.player = 1;
			}
		}
		// chama a funcao fim jogo para se verificar se estao cumpridas as condicoes para terminar o jogo
		y.fimJogo();
	}
}

