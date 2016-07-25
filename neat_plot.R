library(ggplot2)
library(foreach)
library(ggrepel)

portion <- subset(bhat_pval_table, pval > 1e-18)

point_labels <- foreach(i=1:length(portion$drug_num), .combine = "c")%do%{
  paste(bhat_pval_table$drug_name[i], bhat_pval_table$var_name[i], sep="-")
}

ggplot(portion, aes(x=bhat, y=pval, color = drug_name, size = log(pval))) +
  geom_point(alpha=0.3) +
  scale_y_log10() +
  geom_text_repel(aes(label = point_labels), size =3) 
  
  
#the text comes from geom_point_lable


#reverse axes
plot <- ggplot(portion, aes(x=bhat, y=pval, color = drug_name, size = pval)) +
  geom_point(alpha=0.3) +
  geom_text_repel(aes(label = point_labels), size =3, force=20) + 
  scale_y_continuous( trans= "reverse", labels = scientific) +
  guides(size = FALSE)+
  theme(legend.position = "bottom")
plot
plot1 <- ggdraw(switch_axis_position(plot, axis = "x", keep = "y"))
plot1

plot <- ggplot(portion, aes(x=bhat, y=pval, color = drug_name, size = -pval)) +
  geom_point(alpha=0.3) +
  geom_text_repel(aes(label = point_labels), size =3, force=20) + 
  scale_y_continuous(trans = "reverse", labels = scientific) +
  guides(size = FALSE)+
  theme(legend.position = "bottom")
plot
plot1 <- ggdraw(switch_axis_position(plot, axis = "x", keep = "y"))
plot1
