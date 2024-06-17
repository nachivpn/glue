{-# OPTIONS --safe --without-K #-}
module Context.Base (Ty : Set) where

private
  variable
    a b c d : Ty

infix  5 _⊆_
infixl 5 _,,_

-----------
-- Contexts
-----------

data Ctx : Set where
  []   : Ctx
  _`,_ : (Γ : Ctx) → (a : Ty) → Ctx

[_] : Ty → Ctx
[_] a = [] `, a

variable
  Γ Γ' Γ'' ΓL ΓL' ΓL'' ΓLL ΓLR ΓR ΓR' ΓR'' : Ctx
  Δ Δ' Δ'' ΔL ΔL' ΔL'' ΔLL ΔLR ΔR ΔR' ΔR'' ΔRL ΔRR : Ctx
  Θ Θ' Θ'' ΘL ΘL' ΘL'' ΘLL ΘLR ΘR ΘR' ΘR'' ΘRL ΘRR : Ctx
  Ξ Ξ' Ξ'' ΞL ΞL' ΞL'' ΞLL ΞLR ΞR ΞR' ΞR'' ΞRL ΞRR : Ctx

-- append contexts (++)
_,,_ : Ctx → Ctx → Ctx
Γ ,, []       = Γ
Γ ,, (Δ `, x) = (Γ ,, Δ) `, x


------------
-- Variables
------------

data Var : Ctx → Ty → Set where
  zero : Var (Γ `, a) a
  succ : (v : Var Γ a) → Var (Γ `, b) a

pattern v0 = zero
pattern v1 = succ v0
pattern v2 = succ v1

-------------
-- Renamings
-------------

_⊆_  : Ctx → Ctx → Set
Γ ⊆ Γ' = (a : Ty) → Var Γ a → Var Γ' a

variable
  w w' w'' : Γ ⊆ Γ'

⊆-keep : Γ ⊆ Γ' → Γ `, a ⊆ Γ' `, a
⊆-keep r τ v0       = v0
⊆-keep r τ (succ x) = succ (r τ x)

⊆-drop : Γ ⊆ Γ' → Γ ⊆ Γ' `, a
⊆-drop r τ x = succ (r τ x)

⊆-refl[_] : (Γ : Ctx) → Γ ⊆ Γ
⊆-refl[ Γ ] τ x = x

⊆-refl : Γ ⊆ Γ
⊆-refl {Γ} = ⊆-refl[ Γ ]

⊆-fresh[_,_] : (Γ : Ctx) → (a : Ty) → Γ ⊆ (Γ `, a)
⊆-fresh[ Γ , a ] = ⊆-drop ⊆-refl[ Γ ]

⊆-fresh : Γ ⊆ (Γ `, a)
⊆-fresh = ⊆-fresh[ _ , _ ]

⊆-trans : Θ ⊆ Δ → Δ ⊆ Γ → Θ ⊆ Γ
⊆-trans r2 r1 = λ a v → r1 a (r2 a v)

wkVar : Γ ⊆ Γ' → Var Γ a → Var Γ' a
wkVar r v = r _ v 
