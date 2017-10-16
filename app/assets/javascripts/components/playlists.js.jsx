var Playlists = React.createClass({

    render: function() {
        var playlists = this.props.playlists;
        
        return (
            <table>
                <tbody>  
                    {playlists.map((playlist) =>
                        <tr>
                            <td><a href={"/playlists/"+playlist.id}>{playlist.title}</a></td>
                            <td className="date"><a href={"/playlists/"+playlist.id}>{playlist.created_at.toString().substr(0,10)}</a></td>
                            <td className="delete"><a href={"/playlists/"+playlist.id} data-method="delete" data-confirm="Are you sure?"><img src={this.props.trashcan} width="20px" height="20px" className="delete-trash" /></a></td>
                        </tr>
                    )}
                </tbody>
            </table>
        )
    }
})