% Wrap your existing code in a while loop
while true
    % Ask the user for the method first
    disp('Options:');
    disp('1. Bisection Method');
    disp('2. Incremental Method');
    disp('3. Graphical Method');
    disp('4. False Position Method');
    disp('5. Simple Fixed Point Method');
    disp('6. Newton-Raphson Method');
    disp('7. Secant Method');

    method = input('Enter the number of the method to use: ');
    if ~ismember(method, 1:7)
        error('Method must be a number from 1 to 7.');
    end

    while true
        % Then ask for the function
        str_f = input('Enter the function (e.g., "exp(-x) - x"): ', 's');
        f = str2func(['@(x)', str_f]);

        % Ask for the lower bound
        xl = input('Enter the lower bound (e.g., -2): ');
        if ~isnumeric(xl)
            error('The lower bound must be a number.');
        end
        
        x = linspace(xl, xl+10, 1000);

        % Ask for the upper bound if the method is Bisection, False Position or Secant
        if ismember(method, [1, 4, 7])
            xu = input('Enter the upper bound (e.g., 2): ');
            if ~isnumeric(xu)
                error('The upper bound must be a number.');
            end
        end

        % Ask for the delta x if the method is Incremental or Graphical
        if ismember(method, [2, 3])
            delta_x = input('Enter the delta x (e.g., 0.01): ');
            if ~isnumeric(delta_x) || delta_x <= 0
                error('Delta x must be a positive number.');
            end
            x = xl:delta_x:2;
        end

        try 
            root = NaN; 

            if method == 1
                % Bisection Method
                a = xl; 
                b = xu; 
                tol = 1e-6; 
                i = 0; 

                A = [];
                B = [];
                DeltaX = [];
                FXL = [];
                FXMU = [];
                FXLFXMU = [];

                while abs(b-a) > tol
                    c = (a + b) / 2;
                    deltaX = abs(b - a);
                    fxL = f(a);
                    fxMU = f(c);
                    fxlfxmu = fxL * fxMU;
                    A = [A; a];
                    B = [B; b];
                    DeltaX = [DeltaX; deltaX];
                    FXL = [FXL; fxL];
                    FXMU = [FXMU; fxMU];
                    FXLFXMU = [FXLFXMU; fxlfxmu];
                    if f(c) == 0
                        break;
                    elseif f(a)*f(c) < 0
                        b = c;
                    else
                        a = c;
                    end
                    i = i + 1;
                end

                T = table(A, B, DeltaX, FXL, FXMU, FXLFXMU);
                disp(T);

                root = (a + b) / 2;
                disp(['Root found with Bisection Method: ', num2str(root)]);

            elseif method == 2
                % Incremental Method
                if delta_x > 0.01
                    disp('Warning: delta x is too large for Incremental Method. Setting delta x to 0.01.');
                    delta_x = 0.01;
                end
                [min_val, min_index] = min(abs(f(xl:delta_x:2)));
                root = xl + delta_x * (min_index - 1);
                if isnan(root)
                    disp('No root found with Incremental Method');
                else
                    disp(['Root found with Incremental Method: ', num2str(root)]);
                end

            elseif method == 3
                % Graphical Method
                [min_val, min_index] = min(abs(f(x)));
                root = x(min_index);
                disp(['Estimated root from Graphical Method: ', num2str(root)]);

            elseif method == 4
                % False Position Method
                a = xl;
                b = xu;
                tol = 1e-6;
                while abs(b-a) > tol
                    c = a - ((b-a)/(f(b)-f(a)))*f(a);
                    if f(c) == 0
                        break;
                    elseif f(a)*f(c) < 0
                        b = c;
                    else
                        a = c;
                    end
                end
                root = a - ((b-a)/(f(b)-f(a)))*f(a);
                disp(['Root found with False Position Method: ', num2str(root)]);

            elseif method == 5
                % Simple Fixed Point Method
                str_g = input('Enter the function g(x): ', 's');
                g = str2func(['@(x)', str_g]);
                x0 = xl;
                tol = 1e-6;
                while abs(g(x0) - x0) > tol
                    x0 = g(x0);
                end
                root = g(x0);
                disp(['Root found with Simple Fixed Point Method: ', num2str(root)]);

            elseif method == 6
                % Newton-Raphson Method
                df = @(x) (f(x+tol) - f(x)) / tol; % derivative of f
                x0 = xl;
                while abs(f(x0)) > tol
                    x0 = x0 - f(x0)/df(x0);
                end
                root = x0;
                disp(['Root found with Newton-Raphson Method: ', num2str(root)]);

            elseif method == 7
                % Secant Method
                x0 = xl;
                x1 = xu;
                tol = 1e-6;
                while abs(x1 - x0) > tol
                    x_temp = x1 - f(x1)*((x1 - x0)/(f(x1) - f(x0)));
                    x0 = x1;
                    x1 = x_temp;
                end
                root = x1;
                disp(['Root found with Secant Method: ', num2str(root)]);
            end
        catch 
            fprintf('An error occurred while finding the root: %s\n', ME.message);
        end

        if ~isnan(root)
            figure;
            plot(x, f(x), 'b', root, f(root), 'ro');
            title('Root Finding Method');
            xlabel('x');
            ylabel('f(x)');
            grid on;
        end

        % After finding the root, ask the user if they want to use the program again
        again = input('Do you want to use the program again? (1 for yes, 2 for no): ');
        if again == 2
            close all;
            break;
        end
        close all;
        % Ask the user if they want to choose a different method or different values
        choice = input('Do you want to choose a different method or different values? (1 for method, 2 for values): ');
        if choice == 1
            close all;
            break; % Break the inner loop to choose a different method
        elseif choice == 2
            close all;
            continue; % Continue the inner loop to choose different values
        else
            disp('Invalid choice. Starting from the beginning...');
            close all;
            break; % Break the inner loop to start from the beginning
        end
    end

    if again == 2
        close all;
        break; % Break the outer loop to exit the program
    end
end

