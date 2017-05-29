%%Traitement des Images d'obscurité du PLEIADES
% Date de creation: 18.05.2017
% Service CNES: DCT/SI/CD
% Author: Faviola Romero 
% Description: Programme que aide à l'analyse de données d'obscurité du
% satellite PLEIADES. 
% C'est la deuxieme partie, pour l'analise des elements radiatifs. 

clear all,
close all,
clc;

TotalNumberOfCCD = 5;
DefaultThreshold = [3 3 3 3 3];

%% Directory of files

Directory =  '/Users/faviolaromero/Documents/MATLAB/CNES/Programme/Data/'; %this need to be defined as the parent directory

%% Welcome 

% Choix du satellite
Satellite = menu('Veuillez choisir le satellite que vous voluez analyser','PLEAIDES A (lancé le 19.12.2011)','PLEIADES B (lancé le 01.12.2012)');

if Satellite == 1 % 1 = PHRA et 2 = PHRB
   Directory = strcat(Directory,'PHRA/'); 
else 
   Directory = strcat(Directory,'PHRB/');  
end

% Choix du mode PAN ou XS

Mode = menu('Quelle mode vous voulez analyser','Panchromatique','Multispectrale');

%% Partie PAN 
if Mode == 1 % 1= PAN et 2 = XS
   Directory = strcat(Directory,'PAN/'); 
   DataSet = chooseDataSet; % return of the data set as a string: 'Debut', 'Fin", ou 'Evolution'
   Folder = chooseFolder(Satellite, DataSet); % return the PDV choosen
         % special case if folder is the date of sequence longues PHRA beacuse there is 2 sets 
        if strcmp(Folder,'29.12.2011') == 1 
            SpecialFolder = chooseSpecialFolder;
            Folder = strcat(Folder,'/',SpecialFolder);
        elseif strcmp(Folder,'27.01.2012') == 1   
            SpecialFolder = chooseSpecialFolder;
            Folder = strcat(Folder,'/',SpecialFolder);
        end   
  
      Directory = strcat(Directory,DataSet,Folder);

     % function that creates the object (directory, all 5 PAN images are read)
        dernierPDV = PAN(Directory,TotalNumberOfCCD);
     % explanation of how the seuil works  
        Histodialog;  
     % montre l'histogram avec seuil pre-defini   
        showHisto(dernierPDV,DefaultThreshold); 
         
     % Changement de Seuil   
        NewThreshold = newThreshold(DefaultThreshold);
     % montre l'histogram avec nuveau seuil    
        showHisto(dernierPDV,NewThreshold);
        
     % Demander si l'utilisateur veut changer le seuil un fois encore
        ChangementSeuil = menu('Vous voulez changer le seuil un fois encore?','Oui','Non');
             if ChangementSeuil == 1 
                NewThreshold = newThreshold(NewThreshold); 
             end
     
    % fn: search peaks (high and low) and store the data containing them. 
        peaks = searchIonizations(dernierPDV,NewThreshold);
    
    
        % WORK on this function 
        % it is probably a set of functions an each returns a property
   
   
   %% C'est la partie pour analise des pixel chauds et RTS
   
%    allPANccd = menu('Vous voulez analyser tous les 5 barretes?','Oui','Choisir une seule');
%         if allPANccd == 1 
%            
%             % HEEE: we are missing the step to go to a folder called
%             % DERNIER where we store the last PDV available where to choose
%             % the pixels chauds from. Ans also a message that tells us the
%             % PDV that we will take is the last one available. 
%             
%             % function that creates the object (directory, all 5 PAN images are read)
%             dernierPDV = PAN(Directory,TotalNumberOfCCD); 
%            
%            % function to display the histogram, now the threshold is 3sigma by defect, writen on top of the script.
%             showHisto(dernierPDV,DefaultThreshold); 
%             
% 
%             
%             ChangerThreshold = menu('Vous voulez changer le Seuil qui multiplie l"ecartype (par defect 3)?','Oui, je veux!','Non, merci. Montrez-moi les Pixel Chauds!');
% 
%                 % changer le seuil 
%                 if ChangerThreshold == 1
%                     prompt = {'Nouveau valeur de Seuil pour multiplier \sigma'};
%                     name = 'Choix de Seuil des Pixel Chauds';
%                     numlines =1;
%                     defaultanswer = {'3'};
%                     options.Resize='on';
%                     options.WindowStyle='normal';
%                     options.Interpreter='tex';
%                     NewThreshold =inputdlg(prompt,name,numlines,defaultanswer, options);
%                 elseif ChangerThreshold == 2 
%                     NewThreshold = DefaultThreshold;
%                 end
%            
%           % cycle to ask for new seuil 
%           
%                 
%            %Mostrat histo again? 
%          
%            
%            % convertir en tension
%            
%            % convertir en courrant
%            
%          
%                 % also show the mean tension and current of each pixel, wih disvision of each.
%                                 % call a function that displays histo then
%                                 % needs input to continue and closes figure
%                                 % GUI to ask for a SEUIL 
%                                 % sends SEUIL to function that shows hot pixels 
% 
% 
% 
% 
% 
%             % ask for user input of coeffieciente sigma
%             % show hot and cold pixels on matrix 
%             % choose to show trace of only one pixel on the dernier manip 
%                 %chooose to show pixel on time (use always current and tension, and mark noise level for each): 
%                     % 1) analyse EOL (6 last measurements)
%                     % 2) analyse BOL
%                     % 3) Evolution en temps: 
% 
% 
%         else
%             % ask for user input of number of CCD
%                 % same as behind but only with one PAN 
%         end
% 
%         
%    
%    dernier_dir = strcat(Directory,'Dernier/'); % entre dans le dossier contenant le dernier cal obs
%% Partie XS 
    else  %%%%% Partie XS
           Directory = strcat(Directory,'XS/');  
           DataSet = chooseDataSet; % return of the data set as a string: 'Debut', 'Fin", ou 'Evolution'
           Folder = chooseFolder(Satellite, DataSet); % return the PDV choosen
         % special case if folder is the date of sequence longues PHRA beacuse there is 2 sets 
        if strcmp(Folder,'29.12.2011') == 1 
            SpecialFolder = chooseSpecialFolder;
            Folder = strcat(Folder,'/',SpecialFolder);
        elseif strcmp(Folder,'27.01.2012') == 1   
            SpecialFolder = chooseSpecialFolder;
            Folder = strcat(Folder,'/',SpecialFolder);
        end   
  
      Directory = strcat(Directory,DataSet,Folder);

     % function that creates the object (directory, all 20 XS images are read)
     dernierPDV = XS(Directory,TotalNumberOfCCD);
   
   
%    allXSbandes = menu('La partie multispectrale est composé de 4 bandes: Bleu, Vert, Rouge et InfraRouge. Vous voulez analyser toutes les 4 bandes de une seule fois?','Oui','Choisir une seule bande');
%         if allXSbandes == 1
%             % Histogram of all bandes 
%         else
%             XSbande = menu('Choisir la bande','Bleu','Vert','Rouge','Infrarouge');
%             if XSbande == 1
%                 % Ask for user input of number of CCD    %XSccd = menu(
%                 %Histo bleu 
%             elseif XSbande == 2
%                 %histo vert
%                 
%             elseif XSbande == 3
%                 % histo rouge
%                 
%             elseif XSbande == 4
%                 %histo IR
%                 
%             end
%             
%         end
%         
%    

end

