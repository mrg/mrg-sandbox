package t54.app.components;

import org.apache.tapestry5.BindingConstants;
import org.apache.tapestry5.annotations.Import;
import org.apache.tapestry5.annotations.Parameter;
import org.apache.tapestry5.annotations.Property;

@Import(stylesheet="css/layout.less")
public class Layout
{
    @Property
    @Parameter(allowNull=false, defaultPrefix=BindingConstants.LITERAL, required=true)
    private String title;
}
