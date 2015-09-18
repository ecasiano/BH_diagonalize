#a JULIA program for a full diagonalizaiton 
# for an OBC chain in 1D

#Number of particles
const N = 4 
#Number of sites
const M = 4 

#Hamiltonian parameters
const T = -1.0
const U = 1.0

include("BH_basis.jl")
basis = CreateBasis(N,M)
#println(basis)

include("BH_sparseHam.jl")
SparseHam = CreateSparseHam(basis,T,U)
 
#http://docs.julialang.org/en/release-0.3/stdlib/linalg/?highlight=lanczos
d = eigs(SparseHam, nev=1, which=:SR) 
println(U," ",d[2])
  
#------full diag
#reload("BH_fullHam.jl")
#d = eig(FullHam)
#println(d[2][:,1])
#-------

#Begin calculation of the reduced density matrix
Asize = 2 # how many sites in region A
Abasis = Int64[] 
for i=0:N-1
	tempbasis = CreateBasis(N-i,Asize)
	append!(Abasis,tempbasis)
end
tempbasis = zeros(Asize)
append!(Abasis,tempbasis) #this is the reduced basis for region A
#println(Abasis)

#dimension of the total Hilbert space
D = div(length(basis),M)
#dimension of the subspace A
DimA = div(length(Abasis),Asize)
println("DimA ",DimA)
# BDensityM = zeros(D-DimA,D-DimA) #The density matrix over B
 
#perform the Trace_A
for j=1:DimA
	braA = sub(Abasis,(j-1)*Asize+1:(j-1)*Asize+Asize) #unpack the bra/ket 
	index = SerialNum(N,Asize,braA)
	println(j," ",index," ",braA)

# 	for i=1:D
# 		bra = sub(basis,(i-1)*M+1:(i-1)*M+M) #unpack the bra/ket from the total basis vector
# 		subbra = sub(bra,1:Asize)
# 		println("trace ",braA," ",subbra)
# 		println(bra," ",d[2][i]) #this is the eigenvector 
# 
#	end
end

