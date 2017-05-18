%% Traitement des Images d'obscurité du PLEIADES
% Date de creation: 26.04.2017
% Service CNES: DCT/SI/CD
% Author: Faviola Romero 
% Description: Programme que aide à l'analyse de données d'obscurité du
% satellite PLEIADES. Le objectif est de trouver des pixel chauds et de
% comportement RTS. 

clear all,
close all,
clc;

TotalNumberOfCCD = 5;
DefaultThreshold =3;

%% Directory of files

dir =  '/Users/faviolaromero/Documents/MATLAB/CNES/Programme/Data/'; %this need to be defined as the parent directory

%% Welcome 

% Choix du satellite
Satellite = menu('Veuillez choisir le satellite que vous voluez analyser','PLEAIDES A (lancé le 19.12.2011)','PLEIADES B (lancé le 01.12.2012)');

if Satellite == 1 % 1 = PHRA et 2 = PHRB
   dir = strcat(dir,'PHRA/'); 
else 
   dir = strcat(dir,'PHRB/');  
end

% Choix du mode PAN ou XS

Mode = menu('Quelle mode vous voulez analyser','Panchromatique','Multispectrale');

%% Partie PAN 
if Mode == 1 % 1= PAN et 2 = XS
   dir = strcat(dir,'PAN/'); 
   
   allPANccd = menu('Vous voulez analyser tous les 5 barretes?','Oui','Choisir une seule');
        if allPANccd == 1 
           
            % function that creates the object (directory, all 5 PAN images are read)
            dernierPDV = PAN(dir,TotalNumberOfCCD); 
           
           % function to display the histogram, now the threshold is 3sigma by defect, writen on top of the script.
            showHisto(dernierPDV,DefaultThreshold); 
            
            ChangerThreshold = menu('Vous voulez changer le Seuil qui multiplie l"ecartype (par defect 3)?','Oui, je veux!','Non, merci. Montrez-moi les Pixel Chauds!');

                % changer le seuil 
                if ChangerThreshold == 1
                    prompt = {'Nuouveau valeur de Seuil pour multiplier \sigma'};
                    name = 'Choix de Seuil des Pixel Chauds';
                    numlines =1;
                    defaultanswer = {'3'};
                    options.Resize='on';
                    options.WindowStyle='normal';
                    options.Interpreter='tex';
                    NewThreshold =inputdlg(prompt,name,numlines,defaultanswer, options);
                elseif ChangerThreshold == 2 
                    NewThreshold = DefaultThreshold;
                end
           
          % cycle to ask for new seuil 
          
                
           %Mostrat histo again? 
         
           
           % convertir en tension
           
           % convertir en courrant
           
         
                % also show the mean tension and current of each pixel, wih disvision of each.
                                % call a function that displays histo then
                                % needs input to continue and closes figure
                                % GUI to ask for a SEUIL 
                                % sends SEUIL to function that shows hot pixels 





            % ask for user input of coeffieciente sigma
            % show hot and cold pixels on matrix 
            % choose to show trace of only one pixel on the dernier manip 
                %chooose to show pixel on time (use always current and tension, and mark noise level for each): 
                    % 1) analyse EOL (6 last measurements)
                    % 2) analyse BOL
                    % 3) Evolution en temps: 


        else
            % ask for user input of number of CCD
                % same as behind but only with one PAN 
        end

        
   
   dernier_dir = strcat(dir,'Dernier/'); % entre dans le dossier contenant le dernier cal obs
%% Partie XS 
    else  %%%%% Partie XS
   dir = strcat(dir,'XS/');  
   allXSbandes = menu('La partie multispectrale est composé de 4 bandes: Bleu, Vert, Rouge et InfraRouge. Vous voulez analyser toutes les 4 bandes de une seule fois?','Oui','Choisir une seule bande');
        if allXSbandes == 1
            % Histogram of all bandes 
        else
            XSbande = menu('Choisir la bande','Bleu','Vert','Rouge','Infrarouge');
            if XSbande == 1
                % Ask for user input of number of CCD    %XSccd = menu(
                %Histo bleu 
            elseif XSbande == 2
                %histo vert
                
            elseif XSbande == 3
                % histo rouge
                
            elseif XSbande == 4
                %histo IR
                
            end
            
        end
        
   

end


