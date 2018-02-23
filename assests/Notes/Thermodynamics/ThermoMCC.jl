#-------------------------------------------------------------------------------
# Modified Cam_Clay 
# Created by: Vu Nguyen
# Date: August, 24th
#-------------------------------------------------------------------------------
using DataFrames
using PyPlot
#+++++++++++++++++++++++++++++ INPUT INFORMATION ++++++++++++++++++++++++++++++
# Material parameters
    λ   =   0.103 
    κ   =   0.01
    e0  =   0.7
    M   =   1.2
    ν   =   0.3
    eNC =   0.7                       # reference void ratio
    pR  =   98.0                        # reference pressure
    gs  =   2000.0 

# Experiment stages:
    experiment = [
       #  ("isotropic_σControlled"        , "inc = 150"   , "step = 100"),
       #  ("isotropic_σControlled"        , "inc = 2000"  , "step = 1000"),
       #  ("isotropic_σControlled"        , "inc = 130"   , "step = 1000"),
       #  ("isotropic_σControlled"        , "inc = 5000"  , "step = 1000"),
        ("triaxial_CD_σAxial_const"     , "inc = 0.9"   , "step = 10000"),
       #  ("triaxial_CU"                  , "inc = 0.9"  , "step = 100000")
    ]    

# Experiment initial conditions
    σ0 = [98.0, 98.0, 98.0]           # initial stress
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function main()
    
# Experiment initial conditions
    σ = σ0                            # i nitial stressx

    # Initial stress-strain tensor
    ɛᵖ  = zeros(3) 
    ɛᵉ  = zeros(3) 
    ɛ   = zeros(3)
    ɛᵥ  = 0.0 
    ɛᵖᵥ = 0.0 
    f   = 0; Λ = 0; dɛᵖ = 0 ;  dɛᵖᵥ = 0 


    #Initial preconsolidation pressure
    p       = mean(σ)
    lnV     = log(1 + e0)
    lnV_ncl = log(1 + eNC) - λ * log(p/pR)
    pc0     = p * exp((lnV_ncl - lnV) / (λ - κ))
    pc      = pc0
    pi_c    = pc / 2
    println(pc0)

    #writing name of results
    file = open("output.csv", "w")
    write(file, "p, v, q, η, ɛv, σ1, σ2, σ3, ɛ1, ɛ2, ɛ3, v_ncl, ɛpv, e, f, Λ, strainrateR\n")
    write_result(file, σ, ɛ, ɛᵖ, f, Λ, dɛᵖ)

    for(index,value) in enumerate(experiment)
        condition = experiment[index][1]
        step = parse(split(experiment[index][3],"=")[2])
        increment = parse(split(experiment[index][2],"=")[2])

        # Set increment of each conditions 
        if condition == "isotropic_σControlled"
            dσ   = fill((increment-σ[1])/step, 3)
            dɛ  = zeros(3)
        else
            dσ = zeros(3)
            dɛ = [increment/step, 0.0, 0.0]
        end
    
        # Loop for each step in each stage to calculate and update stress & strain
        for i = 1:step

            #-----------------------------------------------------------------------
            # Elastic stiffness matrix
             p = mean( σ) 
            S = σ - p * ones(3)
            q = √(3/2) * vecnorm(S)

            δijδkl = ones(3,3) 
            δkiδlj = eye(3);
        
            Ce = κ/(9*p) * δijδkl + 1/(2*gs) * (δkiδlj - 1/3*δijδkl)
            #-----------------------------------------------------------------------
            # Yield function:
            f = (p - pi_c)^2 / pi_c^2 + q^2 / (M^2 * pi_c^2) - 1
            #------------------------------------------------------------------
            # Elastoplastic compliance matrix
            ∂̂f∂ɛᵖᵥ = (-p^2/pi_c^3 + p/pi_c^2 - q^2/(M^2*pi_c^3) ) * pc0/(λ - κ) * exp(ɛᵖᵥ/(λ - κ))        
            ∂f∂σmm = 2 * (p - pi_c)/pi_c^2 
            ∂f∂σmn = 2/3 * (p - pi_c)/pi_c^2 * ones(3) + 3/(M^2 * pi_c^2) * S
            ∂²G∂σij∂ɛᵖkl = - eye(3)

            # Plastic multiplier
            Λ = (∂f∂σmn' * inv(Ce) * dɛ)[1] / (∂f∂σmm +  ∂f∂σmn' * inv(Ce) * ∂f∂σmn)[1]   

          # Compliance matrix 
            if f >= 0.0  && Λ >= 0.0
                Cep = Ce + ∂²G∂σij∂ɛᵖkl * ∂f∂σmn * ∂f∂σmn' / (∂̂f∂ɛᵖᵥ * ∂f∂σmm)
            else
                Cep = Ce
            end
            #------------------------------------------------------------------
            # Simulate
            if condition == "isotropic_σControlled"
                dɛ = Cep * dσ
            elseif condition == "triaxial_CD_σAxial_const"
                dσ[1] = dɛ[1] / Cep[1,1] 
                dɛ[2] = Cep[2,1] * dσ[1]
                dɛ[3] = dɛ[2]
                dσ[2] = 0.0
                dσ[3] = 0.0
            elseif condition =="triaxial_CU"
                dɛ[2] = -0.5 * dɛ[1]
                dɛ[3] = dɛ[2]
                dσ[3] = (Cep[2,1] * dɛ[1] - Cep[1,1] * dɛ[2])/(Cep[2,1] *
                        (Cep[1,2] + Cep[1,3]) - Cep[1,1]*(Cep[2,2] + Cep[2,3]))
                dσ[2] = dσ[3]
                dσ[1] = 1.0/Cep[1,1] * (dɛ[1] - (Cep[1,2] + Cep[1,3]) * dσ[3])
            end

            dɛᵉ  = Ce * dσ
            dɛᵖ  = dɛ - dɛᵉ
            dɛᵖᵥ = sum(dɛᵖ) 
            dɛᵥ  = sum(dɛ)
            #------------------------------------------------------------------
            # Update
            ɛ   += dɛ 
            ɛᵖ  += dɛᵖ 
            ɛᵉ  += dɛᵉ 
            σ   += dσ
            ɛᵥ  += dɛᵥ  
            ɛᵖᵥ += dɛᵖᵥ  

            pc   = pc0 * exp(ɛᵖᵥ / (λ - κ))
            pi_c = pc / 2.0
            p    = mean(σ)

            # Write result
            write_result(file, σ, ɛ, ɛᵖ,f, Λ, dɛᵖ)
            end   
        end
        close(file)
end
 
#------------------------------------------------------------------------------
function write_result(file::IOStream, σ::Vector, ɛ::Vector, ɛᵖ::Vector, f, Λ, dɛᵖ)
    p       = mean(σ)  
    q       = √(3/2) * vecnorm(σ-p)
    ɛᵥ      = sum(ɛ)
    ɛᵖᵥ     = sum(ɛᵖ)
    lnv     = log(1.0 + e0) - ɛᵥ                   # logarithmic of specific volume
    v       = exp(lnv)                           # specific volume
    e       = v - 1
    lnv_ncl = log(1.0 + eNC) - λ * log(p/pR)

    #CSL    = log(2) * (λ - κ) + eNC 
    lnv_csl = log(1.0 + eNC) - λ * log(p/pR)
    v_ncl   = exp(lnv_ncl)
            
    dɛᵖD    =  √(2/3) * vecnorm(dɛᵖ-sum(dɛᵖ) * ones(3)/3)
    strainrateR = sum(dɛᵖ)/ dɛᵖD
    write(file,"$p,$v,$q,$(q/p),$ɛᵥ,$(σ[1]),$(σ[2]),$(σ[3]),$(ɛ[1]),$(ɛ[2]),$(ɛ[3]),$v_ncl,$ɛᵖᵥ, $e, $f, $Λ,$strainrateR\n")
end 

#------------------------------------------------------------------------------
function plotfig()
    data = readtable("output.csv")
   # figure(figsize=(14,8))
    
    #q - ɛ1
    subplot(331)
    plot(data[:(ɛ1)], data[:q], linestyle = "-",color="green")
    xlabel(L"$\varepsilon_a$", fontsize = 15 )
    ylabel(L"q", fontsize = 15)
    #title("Deviator stress - axial stress", color ="green", fontsize = 13)
    grid("on")

    subplot(332)
    plot(data[:p], data[:q], linestyle = "-",color="green")
    xlim(0,110)
    ylim(0,70)
    xlabel(L"p", fontsize = 15 )
    ylabel(L"q", fontsize = 15)
    grid("on")

    pc0 = 98 
    pi_c = pc0 / 2
    M = 1.2
    p = linspace(0, pc0, 1000);
    q = sqrt(M^2*pi_c^2 * ( 1 - (p - pi_c).^2./pi_c^2));
    plot(p, q)

    p = linspace(0,400,1000)
    qM = p * M
    plot(p, qM)

    # q/p - ɛ1
    subplot(333)
    plot(data[:(ɛ1)], data[:η], linestyle = "-",color="green")
    #title("Stress ratio - axial strain", color = "green", fontsize = 13)
    xlim(-0.2,1)
    xlabel(L"$\varepsilon_a$", fontsize = 15 )
    ylabel(L"$\eta = q/p$", fontsize = 15)
    grid("on")
    
    #eV - ɛ1
    subplot(334)
    plot(data[:(ɛ1)], data[:e], linestyle = "-",color="green")
    xlabel(L"$\varepsilon_a$", fontsize = 15 )
    ylabel(L"e", fontsize = 15)
    grid("on")

    #v-p
    subplot(335)
    plot(data[:p], data[:v], linestyle = "--",color="green")
    plot(data[:p], data[:v_ncl], linestyle = "--",color="blue")
    xlabel(L"p", fontsize = 15)
    ylabel(L"$\nu = 1 + e$", fontsize = 15)
    grid("on")

    #v-lnp
    subplot(336)
    plot(log(data[:p]), log(data[:v]), linestyle = "-",color="green", label ="e-lnp")
    plot(log(data[:p]), log(data[:v_ncl]), linestyle = "--",color="blue", label = "NCL")
    xlabel(L"\ln(p)", fontsize = 15)
    ylabel(L"$\ln(\nu)$", fontsize = 15)
    grid("on")
    #legend()

    #eV-ɛ1
    subplot(337)
    plot(data[:(ɛ1)], data[:ɛv], linestyle = "-",color="green")
    xlabel(L"$\varepsilon_a$", fontsize = 15 )
    ylabel(L"$\varepsilon_v$", fontsize = 15 )
    grid("on")

    #f-q
    subplot(338)
    plot(data[:(q)], data[:f], linestyle = "-",color="green")
    xlabel(L"q ", fontsize = 15)
    ylabel(L"f", fontsize = 15)
    grid("on")

    #f-q
    subplot(339)
    plot(data[:(q)], data[:Λ], linestyle = "-",color="green")
    xlabel(L"q", fontsize = 15)
    ylabel(L"$\Lambda$", fontsize = 15)
    grid("on")

    tight_layout()

    figure()
  #  subplot(331)
    plot(data[:(strainrateR)], data[:η], linestyle = "-",color="green")
    xlabel("strain rate Ratio")
    ylabel("q/p")
    grid("on")
end

#------------------------------------------------------------------------------
function plotfig3()
    data = readtable("output.csv")
   # figure(figsize=(14,6))
    
    #q - ɛ1
    subplot(231)
    plot(data[:(ɛ1)], data[:q], linestyle = "-",color="green")
    xlabel(L"$\varepsilon_a$", fontsize = 15 )
    ylabel(L"q", fontsize = 15)
    #title("Deviator stress - axial stress", color ="green", fontsize = 13)
    grid("on")

    subplot(232)
    plot(data[:p], data[:q], linestyle = "-",color="green")
    xlim(0,300)
    ylim(0,200)
    xlabel(L"p", fontsize = 15 )
    ylabel(L"q", fontsize = 15)
    grid("on")

    pc0 = 98 
    pi_c = pc0 / 2
    M = 1.2
    p = linspace(0, pc0, 1000);
    q = sqrt(M^2*pi_c^2 * ( 1 - (p - pi_c).^2./pi_c^2));
   # plot(p, q)

    p = linspace(0,400,1000)
    qM = p * M
    plot(p, qM)

    # q/p - ɛ1
    subplot(233)
    plot(data[:(ɛ1)], data[:η], linestyle = "-",color="green")
    #title("Stress ratio - axial strain", color = "green", fontsize = 13)
    xlim(-0.2,1)
    ylim(0.0,2.5)
    xlabel(L"$\varepsilon_a$", fontsize = 15 )
    ylabel(L"$\eta = q/p$", fontsize = 15)
    grid("on")
    
    #eV - ɛ1
    subplot(234)
    plot(data[:(ɛ1)], data[:e], linestyle = "-",color="green")
    xlabel(L"$\varepsilon_a$", fontsize = 15 )
    ylabel(L"e", fontsize = 15)
    grid("on")

    #v-p
    subplot(235)
    plot(data[:p], data[:v], linestyle = "--",color="green")
    plot(data[:p], data[:v_ncl], linestyle = "--",color="blue")
    xlabel(L"p", fontsize = 15)
    ylabel(L"$\nu = 1 + e$", fontsize = 15)
    ylim(1.6,2.5)
    grid("on")

    #v-lnp
    subplot(236)
    plot(log(data[:p]), log(data[:v]), linestyle = "-",color="green", label ="e-lnp")
    plot(log(data[:p]), log(data[:v_ncl]), linestyle = "--",color="blue", label = "NCL")
    xlabel(L"\ln(p)", fontsize = 15)
    ylabel(L"$\ln(\nu)$", fontsize = 15)
    ylim(0.5,1.0)
    grid("on")
    #legend()
    tight_layout()
   # savefig("CD.png")
end


#------------------------------------------------------------------------------
function plotfig2()
    data = readtable("output.csv") 
    figure(figsize=(10,6))
    
    subplot(221)
    plot(data[:p], data[:q], linestyle = "-",color="green")
    xlim(0,200)
    ylim(0,200)
    xlabel(L"p", fontsize = 15 )
    ylabel(L"q", fontsize = 15)
    grid("on")

    pc0 = 117 
    pi_c = pc0 / 2
    M = 1.2
    p = linspace(0, pc0, 1000);
    q = sqrt(M^2*pi_c^2 * ( 1 - (p - pi_c).^2./pi_c^2));
    plot(p, q)

    p = linspace(0,400,1000)
    qM = p * M
    plot(p, qM)

    #v-p
    subplot(223)
    plot(data[:p], data[:v], linestyle = "--",color="green")
    plot(data[:p], data[:v_ncl], linestyle = "--",color="blue")
    xlabel(L"p", fontsize = 15)
    ylabel(L"$\nu = 1 + e$", fontsize = 15)
    grid("on")

    #v-lnp
    subplot(224)
    plot(log(data[:p]), log(data[:v]), linestyle = "-",color="green", label ="e-lnp")
    plot(log(data[:p]), log(data[:v_ncl]), linestyle = "--",color="blue", label = "NCL")
    xlabel(L"\ln(p)", fontsize = 15)
    ylabel(L"$\ln(\nu)$", fontsize = 15)
    grid("on")
    #legend()

    #eV-ɛ1
    subplot(222)
    plot(data[:(ɛ1)], data[:ɛv], linestyle = "-",color="green")
    xlabel(L"$\varepsilon_a$", fontsize = 15 )
    ylabel(L"$\varepsilon_v$", fontsize = 15 )
    grid("on")
    tight_layout()
    savefig("Isotropic.png")
end

main()
plotfig3()



