% Configuration Settings for Poker-Bot

% Screen capture settings
config.screenRect = [0, 0, 1920, 1080];  % [left, top, width, height]
config.captureInterval = 1.0;            % Interval between captures in seconds

% Analysis settings
config.analysisDepth = 100;              % Number of hands to consider for player profiling

% Display settings
config.overlayPosition = 'top-right';    % Position of the advice overlay
config.overlayFontSize = 12;             % Font size for the overlay text
config.overlayColor = [0, 255, 0];       % Color of the overlay text in RGB

% Save the configuration to a .mat file
save('config.mat', 'config');
