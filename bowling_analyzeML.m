
%% Initialization

%% Clear and Close Figures
clear ; close all; clc

%% Load Data
data = load('kapil.csv');

% Load 
% i) Overs (O) ii) Economy (E)=Runs/Overs) and iii) OE = Overs*Economy 
% The form of the equation is chosen to  f(x1, x2, x1*x2) or f(x, y, xy)
X = data(:, 4:6);  

% Load the Strike Rate = Wickets/Overs 
% *********** Note the the Strike Rate is NOT the 'batting strike rate' SR != Runs scored/Balls Faced ******
y = data(:, 7);   

% Get the length
m = length(y);

% Plot a scatter plot
figure;
scatter3(X(:,1),X(:,2) ,y,[],[240 15 15],'x');

% Save the maxovers and maxrunsgiven for later
maxovers = max(X(:,1))
maxrunsgiven = max(X(:,2))


% Scale features and set them to zero mean
fprintf('Normalizing Features ...\n');

% The following code has been removed to comply to Coursera' Machine Learning Honor Code
% Normalize 

% Compute Theta

% Calculate Cost

% Now work on creating a surface with the predicted values
hold on;
x = linspace(0,maxovers ,20);
y = linspace(1,maxrunsgiven,20);
[XX, YY ] = meshgrid(x,y);

[a b] = size(XX)

for i=1:a,
   for j= 1:b,
      % Calculate the predicted Strike Rate based on O, E and OE
	  % Since the theta was calculated on normalized values we need to normalize for calculating SR
      ZZ(i,j) = [1 (XX(i,j)-mu(1))/sigma(1) (YY(i,j) - mu(2))/sigma(2)  ...
	    ((XX(i,j)-mu(1))/sigma(1)) .* ((YY(i,j) - mu(2))/sigma(2))	 ] * theta;
	 
   end;
end;
%Plot the surface
mesh(XX,YY,ZZ);

xlabel('Number of overs');
ylabel('Economy rate');
zlabel('Strike rate');
title("Kapil Dev's bowling effectiveness");
print -dpng 'kapil.png';
hold off;


% Display the  result
fprintf('Theta computed through Normal Equation: \n');
fprintf(' %f \n', theta);
fprintf('\n');

% Initialize i=j=1
i=j=1;

%Initialize overs,economy
overs=economy=sr=runs=0;

maxovers = (maxovers/10) * 10
maxeconomy = floor(maxrunsgiven)
for m = 10:10:maxovers, % For Chandra - maximum overs = 51
   for n = 2:maxeconomy,  % Incremet economy rate upto 8(Kumble,Kapil), 6(Chandra)
     
      overs(i,j) = (m - mu(1))/sigma(1); 
      economy(i,j) = (n-mu(2))/sigma(2);
	  over_economy(i,j) = (m - mu(1))/sigma(1) .* (n-mu(2))/sigma(2);
	  % Calculate the bowler's strike rate
      strike_rate(i,j) = [1 overs(i,j) economy(i,j) over_economy(i,j)] * theta;
	  
	  % From the strike rate calculate the predicted wickets 
	  % Predicted wickers = Predicted Strike rate * number of overs
	  
	  wickets(i,j) = strike_rate(i,j) * m;
	  actual_overs(i,j) = m;
	  runs(i,j) = m * n;
	  j = j+1;
   end;
   j=1;
   i = i+1;
end;
figure;
mesh(actual_overs,runs,wickets)
xlabel('Number of overs');
ylabel('Runs given');
zlabel('Predicted wickets');
title("kapil Dev's predicted wickets for number of overs and economy rate");
print -dpng 'kapil-wickets.png' 
% Round the wickets to the nearest whole number
wickets = round(wickets)
save kapil.txt wickets -ascii % save as txt file





