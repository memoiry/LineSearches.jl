let
    lsalphas = [1.0, 0.5,0.5,0.49995,0.5,0.5,0.5]

    f(x) = vecdot(x,x)
    function g!(x, out)
        out[:] = 2x
    end

    x = [-1., -1.]
    df = Optim.DifferentiableFunction(f,g!, x)

    for (i, linesearch!) in enumerate(lsfunctions)
        println("Testing $(string(linesearch!))")

        xtmp = copy(x)
        phi0 = Optim.value_grad!(df, x)
        grtmp = gradient(df)
        p = -grtmp
        dphi0 = dot(p, grtmp)

        lsr = LineSearchResults(eltype(x))
        push!(lsr, 0.0, phi0, dphi0)

        alpha = 1.0
        mayterminate = false

        alpha, f_update, g_update = linesearch!(df, x, p, xtmp, grtmp, lsr, alpha, mayterminate)
        #xnew = x + alpha*p

        @test alpha ≈ lsalphas[i]
    end
end
