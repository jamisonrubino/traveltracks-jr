var Playlists = React.createClass({
    render: function() {
        var all_playlists = this.props.playlists;
        var trash = this.props.trash;
        
        return (
            <table>
                <tbody>
                    {all_playlists.map((playlist) =>
                        <tr>
                            <td><a href={"/playlists/"+playlist.id}>{playlist.title}</a></td>
                            <td className="date"><a href={"/playlists/"+playlist.id}>{playlist.created_at.toString().substr(0,10)}</a></td>
                            <td className="delete"><a href={"/playlists/"+playlist.id} data-method="delete" data-confirm="Are you sure?"><img src={trash} width="14px" height="16px" className="delete-trash" /></a></td>
                        </tr>
                    )}
                </tbody>
            </table>
        )
    }
})