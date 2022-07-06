/* TUTTE LE INTERROGAZIONI RICHIEDONO INPUT, PERTANTO SONO STATI INSERITI TEMPORANEAMENTE DEI VALORI DI DEFAULT*/

#OPERAZIONE 1
#Trovare tutti gli atleti under “X”, attaccanti che hanno segnato più di “Y” reti nella competizione “W” 

#CON VISTA - ATLETAPOSIZIONI

select ID,Nome,Cognome
from AtletaPosizioni
where ((Year(current_date())-Year(DataNascita)<=34) and Ruolo='Attaccante' and ID in (select distinct Atleta from statistiche_torneo where (Gol>2 and CompetizioneNome='Campionato')));

#SENZA VISTA
select ID,Nome,Cognome
from Atleta join Ricopre on ID=Atleta
where ((Year(current_date())-Year(Data_di_nascita)<=34) and Posizione='Attaccante' and ID in (select distinct Atleta from statistiche_torneo where (Gol>2 and CompetizioneNome='Campionato')));


#######################################################################################################################
#OPERAZIONE 2
#Trovare le generalità dell’agente  che fino all’anno “X” ha concluso i trasferimenti più onerosi.

#CON VISTA - TRASFERIMENTIAGENTE
select Codice,Nome_Agente,Cognome_Agente
from trasferimentiagente where(ID_trasferimento in (select ID_trasferimento from trasferimenti 
															 where (Year(Data_inizio)<2018)))
															group by (Codice)
															order by sum(Somma) desc limit 1 ; 



#SENZA VISTA
select Codice,Nome,Cognome 
from Agente
where (Codice =   (select Agente
				  from Atleta join Trasferimenti on ID=Atleta 
                 where(ID_trasferimento in (select ID_trasferimento from trasferimenti 
															 where (Year(Data_inizio)<2018)))
                                                             group by (Agente)
                                                             order by sum(Somma_trasferimento) desc limit 1 )); 




############################################################################
#OPERAZIONE 3
#Trovare nome e cognome e numero trofei totali  dei  giocatori che giocano in un determinato ruolo “X”  e che calciano con il piede “Y”

# CON VISTA - ATLETAPOSIZIONI 

select Nome, Cognome, Trofei_totali(Numero_trofei_squadra,Numero_trofei_personali) as Trofei_Totali
from atletaposizioni join palmarès on palmarès.Atleta=Atletaposizioni.ID
where ( Ruolo='Centrocampista' and  ID in (select Atleta from caratteristiche where (Piede='Sx'))); 

#SENZA VISTA

select Nome,Cognome,Trofei_totali(Numero_trofei_squadra,Numero_trofei_personali) as Trofei_Totali
from Atleta join palmarès on ID=Atleta
where (ID in (select caratteristiche.Atleta 
			 from caratteristiche join ricopre on caratteristiche.Atleta=ricopre.Atleta 
			 where(Piede='Sx' and Posizione='Centrocampista')));


###################################################################################
#OPERAZIONE 4
#Trovare Nome e cognome dell’atleta che è stato acquistato più di una volta dalla stessa squadra
#SENZA VISTA

select ID,Nome,Cognome from Atleta where (ID in 
								(select Atleta from trasferimenti group by Atleta,Acquirente having count(Acquirente)>=2)); 

#################################################################################### 
#OPERAZIONE 5
#AGGIORNAMENTO STATISTICHE
/*
Update Statistiche_torneo SET Gol=(Gol+ ?), Assists=(Assists+?), Presenze=(Presenze+ ?),Espulsioni=(Espulsioni+?),
						 Ammonizioni=(Ammonizioni+?),Doppie_Ammonizioni=(Doppie_Ammonizioni+?)
						 where (Atleta=? and EdizioneA=? and CompetizioneNome=?);
*/
#################################################################################
#OPERAZIONE 6
#Trovare il difensore con meno ammonizioni(o sanzioni) nelle partite di campionato

#CON VISTA - AMMONIZIONECAMPIONATO - ATLETAPOSIZIONI 

select ID, Nome,Cognome,Ammonizioni from  AmmonizioniCampionato join atletaposizioni  On Atletaposizioni.ID=AmmonizioniCampionato.Atleta where (Ruolo='Difensore') order by(Ammonizioni) limit 1; 
                                            
#SENZA VISTA
select ID,Nome,Cognome,sum(Ammonizioni) as Ammonizioni
			from statistiche_torneo join ricopre join Atleta on Statistiche_torneo.Atleta=Ricopre.Atleta and Atleta.ID=Statistiche_torneo.Atleta
			where (CompetizioneNome='Campionato' and Posizione='Difensore')
			group by (Statistiche_torneo.Atleta)
			order by sum(Ammonizioni) limit 1 ;

					
##########################################################################
#OPERAZIONE 7
#Trovare ID,nome e cognome degli atleti con somma di trasferimento minore o uguale a “X” e che il contratto attuale disponga di un ingaggio non superiore “Y”

#SENZA VISTA
select Nome, Cognome,ID
from Atleta as A
where ( ID in (select Atleta
				from trasferimenti as T
				 where (T.Somma_trasferimento<='3000000' and T.Atleta = any (select Atleta 
																		from contratti as C
																		where ( C.Ingaggio<=2000000 and Scaduto=0 ))))); 


########################################################################
#OPERAZIONE 8
#Trovare la nazione che ha atleti under “X” con più “Y” (assist,gol..)
#SENZA VISTA
select Nazionalità  from atleta join statistiche_torneo on ID=Atleta 
where (Year(current_date())-Year(Data_di_nascita)<=20)  
group by (Nazionalità) 
order by  sum(Assists) desc limit 1; 

#################################### 
#OPERAZIONE 9
#Trovare gli atleti che hanno subito un infortunio nell’ultimo anno

select ID,Nome,Cognome,Data_inizio,Data_fine from atleta join infortuni on ID=Atleta 
where (Year(Data_inizio)=Year(current_date())-1 and Year(Data_fine)=Year(current_date())-1); 


#####################################    
#OPERAZIONE 10
#Trovare ID degli atleti che hanno partecipato ad una competizione “X” negli ultimi “W” anni  e che hanno come agente “Nome Y e Cognome Z

#CON VISTA  - AGENTEATLETA
select ID_Atleta as Atleta from agenteatleta  where (Nome_Agente='Mino' and Cognome_Agente='Raiola' and ID_Atleta = any (select ID from partecipa where (CompetizioneNome='Coppa' and Year(current_date())-5)));

#SENZA VISTA
select ID as Atleta from atleta join agente on Agente=Codice 
where (Agente.Nome='Mino' and Agente.Cognome='Raiola' and ID = any (select ID from partecipa where (CompetizioneNome='Coppa' and Year(current_date())-5)));



#####################################
#OPERAZIONE 11
#Trovare l'agente che ha “ruolo X” con il maggior numero di "statistica Y” nell’ultima stagione


#SENZA VISITA
select Codice,Nome,Cognome
from Agente
where (Codice = (select Agente
				 from statistiche_torneo join atleta on ID=Atleta 
				 where (ID in (select Atleta from Ricopre 
									 where (Posizione='Centrocampista')))
																		   group by(Agente) 
																		   order by sum(Assists) desc limit 1));
#CON VISTA - STATISTICHETOTALIGIOCATORI
select Codice,Nome,Cognome 
from Agente 
where (Codice =(
		select Agente
		from statistichetotaligiocatori,ricopre 
		where (ID=Atleta and Posizione='Centrocampista')
		group by (Agente)
		order by Assist desc limit 1));



############################################
#OPERAZIONE 12
#Trovare le calciatrici che sono assistite dall’agente che ha i calciatori più proficui in termini di gol e assist in tutte le competizioni

#SENZA VISTA
select ID,Nome,Cognome,Nazionalità,Genere,Data_di_nascita,Valore_di_mercato,Agente
from Atleta 
where (Genere='F' and Agente= (select Codice
								from atleta, (select Atleta ,sum(Gol+Assists) As TotaleGA from statistiche_torneo group by Atleta ) as T , Agente
								where (Atleta.ID=T.Atleta and Agente.Codice=Agente and Genere='M')
								group by (Codice)
								order by Sum(TotaleGa) desc limit 1)) ;

#CON VISTA - StatisticheTotaligiocatori
select ID,Nome,Cognome,Nazionalità,Genere,Data_di_nascita,Valore_di_mercato,Agente
from Atleta 
where (Genere='F' and Agente= (select Codice
								from statistichetotaligiocatori as T , Agente
								where ( Agente.Codice=Agente and Genere='M')
								group by (Codice)
								order by Sum(Gol+Assist) desc limit 1));


###########################################################
#OPERAZIONE 13
#Trovare gli atleti che hanno il maggior numero di partecipazioni a una determinata competizione


#Senza Vista

select Atleta.ID,Nome,Cognome,CompetizioneNome,count(CompetizioneNome) as Partecipazione
from Atleta,Partecipa 
where ( Atleta.ID=Partecipa.ID and CompetizioneNome='Mondiale')
group by (Atleta.ID)
having Partecipazione >= all (select count(CompetizioneNome) as Partecipazione
							from Atleta,Partecipa 
							where ( Atleta.ID=Partecipa.ID and CompetizioneNome='Mondiale')
							group by (Atleta.ID));
                           


#CON VISTA - GIOCATORIPARTECIPAZIONI
select ID,Nome,Cognome,Competizione,Partecipazioni
from Giocatorepartecipazioni
where (Competizione='Mondiale')
Having Partecipazioni >= all (select Partecipazioni 
							 from Giocatorepartecipazioni 
							where (Competizione='Mondiale'));
                            
#°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
/*

TUTTE LE INTERROGAZIONI RICHIEDONO INPUT, PERTANTO SONO STATI INSERITI TEMPORANEAMENTE DEI VALORI DI DEFAULT
Operazioni: 
1(V),2(V),3(V),4,6(V),5,7,8,9,10(V),11(V),12(V),13(V)	
Tutte le operazioni con (V) sono state fatte anche con le viste	
*/
#°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
