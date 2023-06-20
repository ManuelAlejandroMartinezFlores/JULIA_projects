function secret_handshake(code)
    actions = []
    cnt = 1
    posible = ["wink", "double blink", "close your eyes", "jump", "reverse"]
    for dig in digits(code, base=2)
        if cnt == 6 
            break
        end
        if dig == 1
            push!(actions, posible[cnt])
        end 
        cnt += 1
    end 
    if length(actions) == 0
        return actions 
    end
    if actions[end] == "reverse"
        return reverse(actions[1:end-1])
    end 
    return actions
end
