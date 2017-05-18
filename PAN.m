classdef PAN
    %   PAN Class refering to all PAnchromatic CCDs in Pleaides mission 
    %   Revision: 10.05.2017 
    %   Pleaides mission is a constellation of 2 satellites,
    %   PHR1A and PHR1B which provide images of high resolution of the
    %   Earth. 
    %   The insrument on each satellite is composed of 5 Panchromatic CCDs.
    
    properties (Constant) 
        nPixels    = double(5984);
    end
    
    properties (Hidden) % They are not shown with the object list
        % the list of gains for each ampli, listed as each OS from 10 to 1
        GainsPHRA1 = [3.22 3.22 3.19 3.23 3.21 3.29 3.32 3.32 3.36 3.51]; % Gains of CCD 1 ou E, piece #216
        GainsPHRA2 = [3.51 3.43 3.39 3.36 3.39 3.32 3.41 3.41 3.42 3.45]; % Gains of CCD 2 ou D, piece #212
        GainsPHRA3 = [3.35 3.24 3.24 3.22 3.08 3.13 3.11 3.12 3.14 3.37]; % Gains of CCD 3 ou C, piece #192
        GainsPHRA4 = [3.64 3.48 3.43 3.37 3.35 3.23 3.31 3.35 3.36 3.68]; % Gains of CCD 4 ou B, piece #189
        GainsPHRA5 = [3.37 3.35 3.29 3.31 3.27 3.41 3.43 3.35 3.33 3.32]; % Gains of CCD 5 ou A, piece #193 * (originalement le piece #200)
        
        GainsPHRB1 = [3.45 3.34 3.32 3.30 3.23 3.33 3.41 3.43 3.51 3.65]; % Gains of CCD 1 ou E, piece #286
        GainsPHRB2 = [3.40 3.35 3.33 3.33 3.25 3.22 3.31 3.34 3.39 3.43]; % Gains of CCD 2 ou D, piece #285
        GainsPHRB3 = [3.24 3.20 3.16 3.15 3.11 3.21 3.23 3.22 3.21 3.27]; % Gains of CCD 3 ou C, piece #252
        GainsPHRB4 = [3.48 3.40 3.40 3.39 3.35 3.27 3.34 3.32 3.33 3.37]; % Gains of CCD 4 ou B, piece #284
        GainsPHRB5 = [3.50 3.45 3.41 3.41 3.35 3.43 3.46 3.43 3.44 3.46]; % Gains of CCD 5 ou A, piece #245
       
        CVF        = 2.34e-6 % CVF is different for each OS, but since it is such a small value, we will use the same for all 
        
        Kcan       = 4096/900e-3;  % Cte de conversion Analoguique - Numeric 
        Offset     = 31.5;  % Asservissement offset, 31.5 [LSB], utilise pour eviter del valeurs negatifs sur les données
        Sutile     = 1.69e-10;     % Surface utile du pixel = 13x13micrometres^2
        nTDI       = 13;           % etages TDI  
        nEtMasques = 9;            % Etages masques 
        Smasque    = 3.9e-10;      % Surface masque = 13x30micrometres^2
        Tligne     = 103.5e-6;     % Temps d'integration per ligne 
        q          = 1.6e-19       % Charge in coulombs
    end
    
    properties
        Dossier     
        DatePDV
        Satellite   % Which satellite 'PHR1A' or 'PHR1B'
        Mode        % Mode of view 'XS' or 'PAN'
        nLignes     %= 7256
        % Temperature 
        SourceImages
        %ValeurTension
        %ValeurCourant
               
    end
    
    
    
    
   
    methods
        
        function obj = PAN(dossier,TotalNumberOfCCD)
            % Fonction pour creer l'object PAN
            
            % aller au dossier et après charger l'info de fichier XML  
            xmlfile_1 = fullfile(dossier,'sag_descripteur.xml');
            xDoc_1 = xmlread(xmlfile_1);
            
            obj.Dossier = dossier;
            obj.DatePDV = char(xDoc_1.getElementsByTagName('datePDV').item(0).getTextContent);
            obj.Satellite = char(xDoc_1.getElementsByTagName('satellite').item(0).getTextContent);
            obj.Mode = char(xDoc_1.getElementsByTagName('modeTraitement').item(0).getTextContent);
            obj.nLignes = str2double(xDoc_1.getElementsByTagName('nbLignes').item(0).getTextContent);
            
            % Lecture des images
            obj.SourceImages = zeros(obj.nLignes,obj.nPixels,TotalNumberOfCCD);

                for ccdPAN = 1 : TotalNumberOfCCD 
                    disp('Reading images...');
                    image_jp2 = imread(strcat(dossier,'IMG_PA_',num2str(ccdPAN),'.JP2'));
                    image_double = double(image_jp2);
                    obj.SourceImages(:,:,ccdPAN) = image_double;
                    Progress = [ccdPAN*100/TotalNumberOfCCD '%'];
                    disp(Progress);
                end
            % - l'object a été crée - %
            
        end
        
        function showHisto(obj,Seuil)
            % Function pour montrer l'histogram de tous les 5 barrette PAN. 
            % si l'object s'agit de tous les barettes, sinon il prende le numero de dimensions crees dans le partie obj.SourceImages 
            
            Mean = mean(obj.SourceImages);
            Sigma = std(Mean);
            MeanOfMeans = mean(Mean);
            DetectionThreshold = Seuil*Sigma;
            [~,~,TotalNumberOfCCD] = size(Mean);
            
            
            for ccdPAN = 1 : TotalNumberOfCCD
            histogram(Mean(:,:,ccdPAN));
            figure(1)
            hold on
            ylim = get(gca,'ylim');
            line ([MeanOfMeans(:,:,ccdPAN)+DetectionThreshold(:,:,ccdPAN) MeanOfMeans(:,:,ccdPAN)+DetectionThreshold(:,:,ccdPAN) NaN MeanOfMeans(:,:,ccdPAN)-DetectionThreshold(:,:,ccdPAN) MeanOfMeans(:,:,ccdPAN)-DetectionThreshold(:,:,ccdPAN)] , [ylim NaN ylim], 'color','g');
            title(sprintf('%s, mode %s, CCD %i',obj.Satellite, obj.Mode, ccdPAN));
           xlabel('Niveau numerique du pixel sans offset [LSB]');
            ylabel('Occurrence [Events]');
            legend('Barrette Histogramme',[sprintf('Seuil de detection = %d',Seuil) '\sigma']);
            input('Appuyez sur "Enter" pour continuer');
            close all;
            end
        end
        
        function obj=source2lsb(obj)
            % fonction que substrait l'Offset de 31.5 LSB pour montrer le
            % vrai valeur en LSB
            obj.SourceImages = obj.SourceImages-obj.Offset;
        end
        
        function obj=lsb2tension(obj)
            % fonction pour remonter le valuer LSB en Tension 
            % Vobs = ValeurLSB / ( Kcan*GainAmpli)
        end
        
        function obj=tension2courant(obj)
            % fonction pour remonter du tension au courant 
            % Iobs = (Vobs*q) / (CVF*Tligne)*(Sutile*Ntdi+9*Smasked)
        end
        
        
        
        % then, show the tenstion and current value when you choose only one CCD
         % or in a matrix with a color map 
         
            
        
            %% Gain of ampli search 
%             gain_number = 5*Bande + XSccd;
%             
%             if strcmp(obj.Satellite,'PHR1A') == true
%                 obj.G_amp = obj.All_Gains_A(gain_number);
%             else
%                 obj.G_amp = obj.All_Gains_B(gain_number);
%             end 
        
        
    end

     
end