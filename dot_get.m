clc
clear all
close all
%% 


sz = [5704 3];
varTypes = ["string","double","double"];
varNames = ["FileName","CEJ","ABB"];
temps = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames)

temps.ABB{1} = double.empty(size(centers, 1), 4)
save("testTable.mat","temps")
%% 

imds=imageDatastore('half_teeth_from_annotated');

[sorted, INDEX] = sort_nat(imds.Files);

no_of_images = countlabels(sorted);

data = load('teeth_4.mat');
vehicleDataset = data.vehicleDataset;

dataSet = vehicleDataset.vehicle;
sizeOfDataSet = height(vehicleDataset);

for i=1 : sizeOfDataSet

double = vehicleDataset.vehicle{i, 1};
for j=1 : size(double, 1)
for k=1 : size(double, 2)
if double(j, k) == 0
vehicleDataset.vehicle{i, 1}(j, k) = double(j, k) + 1;
end
end
end
end
%for i=1 : 1
for i=1 : sizeOfDataSet
double = vehicleDataset.vehicle{i, 1};
for j=1 : size(double, 1)
for k=1 : size(double, 2)
if double(j, k) ~= 0 && double(j, k) ~= 1
vehicleDataset.vehicle{i, 1}(j, k) = double(j, k) - 1;
end
end
end
end




%% 

for j = 1 : 5704
    rgb = imread(sorted{j});
    [BW, yellowMasked] = YellowDotMask(rgb);
    [BW, redMasked] = RedDotColorMask(rgb);
    %imshow(rgb)
    [centers,radii] = imfindcircles(yellowMasked,[6 10],'ObjectPolarity','bright','Sensitivity',0.98,'EdgeThreshold',0.4);
    [centerRed, radiiRed] = imfindcircles(redMasked, [6 10], 'ObjectPolarity','bright','Sensitivity',0.98,'EdgeThreshold',0.7);
    %hBright = viscircles(centers, radii);
    %BBright = viscircles(centerRed, radiiRed,'Color','b');
    
    temps.FileName{j} = sorted{j};
    if (~isempty(centers))
        temps.ABB{j} = double.empty(size(centers, 1), 4)
        for cY = 1 : size(centers, 1)
            xPos = centers(cY, 1) - radii(cY);
            yPos = centers(cY, 2) - radii(cY);
            if (xPos < 1)
                xPos = 1;
            end
            if (yPos < 1)
                yPos = 1;
            end
            
            temps
            vehicleDataset.vehicle{j}(cY, 1) = xPos;
            vehicleDataset.vehicle{j}(cY, 2) = yPos;
            vehicleDataset.vehicle{j}(cY, 3) = radii;
            vehicleDataset.vehicle{j}(cY, 4) = radii;
        end
    end

end


  vehicleDataset = renamevars(vehicleDataset,["imageFilename", "vehicle"], ["IMfilename", "ABB"]);
