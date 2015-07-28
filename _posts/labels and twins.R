labels and twins tutorial
nth = 5
nv  = 4
thresh <- mxMatrix( type="Full", nrow=nth, ncol=nv, free=T, values=0.1, lbound=-3, ubound=3, name = "thresh")

tlabels = c()
for (c in 1:(nv/2)) {
	tlabels = c(tlabels, paste0("v", c, "_thresh", 1:nth))
	# labels like: "v1_thresh1" "v1_thresh2" "v1_thresh3" "v1_thresh4" "v1_thresh5"
}
thresh$labels = tlabels # this fills twin1's labels, then floods over and fills twin 2 with the same labels.
thresh$labels
#      [,1]         [,2]         [,3]         [,4]
# [1,] "v1_thresh1" "v2_thresh1" "v1_thresh1" "v2_thresh1"
# [2,] "v1_thresh2" "v2_thresh2" "v1_thresh2" "v2_thresh2"
# [3,] "v1_thresh3" "v2_thresh3" "v1_thresh3" "v2_thresh3"
# [4,] "v1_thresh4" "v2_thresh4" "v1_thresh4" "v2_thresh4"
# [5,] "v1_thresh5" "v2_thresh5" "v1_thresh5" "v2_thresh5"

t1cols = c(1,3)
t2cols = c(2,4)

thresh$labels[,t1cols] = tlabels # fill T1 columns
thresh$labels[,t2cols] = tlabels # fill T2 columns
thresh$labels
#      [,1]         [,2]         [,3]         [,4]
# [1,] "v1_thresh1" "v1_thresh1" "v2_thresh1" "v2_thresh1"
# [2,] "v1_thresh2" "v1_thresh2" "v2_thresh2" "v2_thresh2"
# [3,] "v1_thresh3" "v1_thresh3" "v2_thresh3" "v2_thresh3"
# [4,] "v1_thresh4" "v1_thresh4" "v2_thresh4" "v2_thresh4"
# [5,] "v1_thresh5" "v1_thresh5" "v2_thresh5" "v2_thresh5"





I'll jsut say that the only scientific evidence that children with Austism require teaching that eschews phonics in favour of strategies that shift the focus to the visual would be a (very simple) RCT of phonics and visual learning for children with Austism.

None of what follows is that evidence:

"it doesn’t necessarily follow" is not relevant: One can add "It doesn't necessarily follow" to the end of absolutely any interesting statement.

Likewise "general principle" doesn't answer the question:
   Crutches are useful for amputees. As a general princple, they are not useful.

If Goyen et al. (1984) showed that phonics was effective for autism, it's relevant, otherwise it's not.
   Testing the claim "A works for most Bs" does not test the claim "A is best for group C"

“Children with ASD may benefit from phonics instruction consistent with the NRP"

The word "may" vitiates this as evidence for anything at all.

The Dehaene (2009) reference is not germain: the claim is not that "there are hundreds of ways to learn to read", it is that one of the two ways to learn (GPC route) is broken in Autism. I have no idea if it is, but the reference is irrelevant.

Do you have any RCT trial of phonics in children with autism showing it is effective?

http://theconversation.com/children-with-autism-arent-necessarily-visual-learners-42758


European Court decides sites like twitter are responsible for your speech: Which means they can't let you speak ☹

